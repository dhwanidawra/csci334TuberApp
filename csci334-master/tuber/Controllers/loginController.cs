using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

//https://local:5001/api/login/

namespace tuber
{
    [Route("api/[controller]")]
    [ApiController]
    public class loginController : ControllerBase
    {
        private readonly tuber_databaseContext _context;

        public loginController() 
        {
            _context = new tuber_databaseContext(); 
        }

        // POST: { "UsersId": "DrNoobopolis", "Password": "P3NIZ" }
        [HttpPost]
        public async Task<ActionResult<Users>> login(Users input)
        {
            Users query = await _context.Users.FindAsync(input.UsersId);

            return query; 
        }

    }

}
