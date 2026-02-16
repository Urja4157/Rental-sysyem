using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using RentalSystem.Infrastructure.Repositories;

namespace RentalSystem.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class MigrateController : ControllerBase
    {
        private readonly RentalManagementDbContext _dbContext;
        public MigrateController(RentalManagementDbContext dbContext)
        {
            _dbContext = dbContext;
        }

        [HttpPost("ApplyMigrations")]
        public IActionResult ApplyMigrations()
        {
            _dbContext.Database.Migrate();
            return Ok("Migrations applied!");
        }
    }
}

