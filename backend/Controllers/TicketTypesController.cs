using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using TransitFlow.API.Data;
using TransitFlow.API.DTOs;

namespace TransitFlow.API.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class TicketTypesController : ControllerBase
{
    private readonly ApplicationDbContext _context;

    public TicketTypesController(ApplicationDbContext context)
    {
        _context = context;
    }

    [HttpGet]
    public async Task<ActionResult<List<TicketTypeDto>> > GetAll([FromQuery] bool? isActive = null)
    {
        var query = _context.TicketTypes.AsQueryable();

        if (isActive.HasValue)
        {
            query = query.Where(t => t.IsActive == isActive.Value);
        }

        var types = await query
            .Select(t => new TicketTypeDto
            {
                Id = t.Id,
                Name = t.Name,
                Description = t.Description,
                ValidityDays = t.ValidityDays,
                IsActive = t.IsActive
            })
            .ToListAsync();

        return Ok(types);
    }
}
