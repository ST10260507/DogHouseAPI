using Microsoft.AspNetCore.Mvc;
using DogHouseAPI.Models;
using System.Collections.Generic;
using System.Linq;
using Google.Cloud.Firestore;
using System.Threading.Tasks;
using System;

[ApiController]
[Route("[controller]")]
public class DogsController : ControllerBase
{
    private readonly FirestoreDb _firestoreDb;
    private const string DogsCollectionPath = "Admin/AdminUserDocument/AddDog";

    public DogsController()
    {
        _firestoreDb = FirestoreDb.Create("kzn-doghouse");
    }

    [HttpGet("filter")]
    public async Task<ActionResult<IEnumerable<DogDataRecord>>> GetFilteredDogs(
        [FromQuery] int? age,
        [FromQuery] string? breed,
        [FromQuery] bool? IsVaccinated,
        [FromQuery] bool? IsSterilized)
    {
        try
        {
            QuerySnapshot dogsSnapshot = await _firestoreDb.Collection(DogsCollectionPath).GetSnapshotAsync();

            var dogsList = dogsSnapshot.Documents
                .Where (doc => doc.Exists)
                .Select(doc =>
                {
                    try
                    {
                        return new DogDataRecord
                        {
                            DocumentId = doc.Id,
                            Name = doc.GetValue<string>("name"),
                            Breed = doc.GetValue<string>("breed"),
                            Sex = doc.GetValue<string>("sex"),
                            Bio = doc.GetValue<string>("bio"),
                            Age = (int)doc.GetValue<long>("age"), 

                            IsVaccinated = doc.GetValue<bool>("isVaccinated"),
                            IsSterilized = doc.GetValue<bool>("isSterilized"), 

                            Status = doc.GetValue<string>("status"),
                            ImageUrl = doc.GetValue<string>("imageUrl"),
                            DateAdded = doc.GetValue<Timestamp?>("dateAdded")?.ToDateTime()  
                        };
                    }
                    catch (Exception mapEx)
                    {
                        Console.WriteLine($"Error mapping document {doc.Id}: {mapEx.Message}");
                        return null;
                    }
                })
                .Where(d => d != null)
                .ToList();

            var query = dogsList.AsQueryable();

            if (age.HasValue)
            {
                query = query.Where(d => d.Age <= age.Value); 
            }

            if (!string.IsNullOrEmpty(breed))
            {
                query = query.Where(d => d.Breed.Equals(breed, StringComparison.OrdinalIgnoreCase));
            }

            if (IsVaccinated.HasValue)
            {
                query = query.Where(d => d.IsVaccinated == IsVaccinated.Value);
            }

            if (IsSterilized.HasValue)
            {
                query = query.Where(d => d.IsSterilized == IsSterilized.Value);
            }

            return Ok(query.ToList());
        }
        catch (Exception ex)
        {
            Console.WriteLine($"FATAL Error in GetFilteredDogs: {ex.Message}");
            return StatusCode(500, "Internal server error while fetching data from Firestore.");
        }
    }
}