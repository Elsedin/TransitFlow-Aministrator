using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using TransitFlow.API.Data;
using TransitFlow.API.DTOs;

namespace TransitFlow.API.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class ZonesController : ControllerBase
{
    private readonly ApplicationDbContext _context;

    public ZonesController(ApplicationDbContext context)
    {
        _context = context;
    }

    [HttpGet]
    public async Task<ActionResult<List<ZoneDto>>> GetAll([FromQuery] bool? isActive = null)
    {
        var query = _context.Zones.AsQueryable();

        if (isActive.HasValue)
        {
            query = query.Where(z => z.IsActive == isActive.Value);
        }

        var zones = await query
            .OrderBy(z => z.Name)
            .ToListAsync();

        var result = zones.Select(z => new ZoneDto
        {
            Id = z.Id,
            Name = z.Name,
            Description = z.Description,
            IsActive = z.IsActive
        }).ToList();

        return Ok(result);
    }
}
