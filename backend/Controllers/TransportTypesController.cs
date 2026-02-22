using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using TransitFlow.API.Data;
using TransitFlow.API.DTOs;

namespace TransitFlow.API.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class TransportTypesController : ControllerBase
{
    private readonly ApplicationDbContext _context;

    public TransportTypesController(ApplicationDbContext context)
    {
        _context = context;
    }

    [HttpGet]
    public async Task<ActionResult<List<TransportTypeDto>>> GetAll()
    {
        var types = await _context.TransportTypes
            .Where(t => t.IsActive)
            .Select(t => new TransportTypeDto
            {
                Id = t.Id,
                Name = t.Name
            })
            .ToListAsync();

        return Ok(types);
    }
}
