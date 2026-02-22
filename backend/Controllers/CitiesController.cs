using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using TransitFlow.API.Data;
using TransitFlow.API.DTOs;

namespace TransitFlow.API.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class CitiesController : ControllerBase
{
    private readonly ApplicationDbContext _context;

    public CitiesController(ApplicationDbContext context)
    {
        _context = context;
    }

    [HttpGet]
    public async Task<ActionResult<List<CityDto>>> GetAll([FromQuery] bool? isActive = null)
    {
        var query = _context.Cities
            .Include(c => c.Country)
            .AsQueryable();

        if (isActive.HasValue)
        {
            query = query.Where(c => c.IsActive == isActive.Value);
        }

        var cities = await query
            .OrderBy(c => c.Name)
            .ToListAsync();

        var result = cities.Select(c => new CityDto
        {
            Id = c.Id,
            Name = c.Name,
            PostalCode = c.PostalCode,
            CountryId = c.CountryId,
            CountryName = c.Country?.Name ?? string.Empty,
            IsActive = c.IsActive
        }).ToList();

        return Ok(result);
    }
}
