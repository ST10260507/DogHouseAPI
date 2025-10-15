using Microsoft.AspNetCore.Mvc;
using DogHouseAPI.Models;
using System.Collections.Generic;
using System.Linq;
using Google.Cloud.Firestore;
using System.Threading.Tasks;

[ApiController]
[Route("[controller]")]
public class DogsController : ControllerBase
{
    private readonly FirestoreDb _firestoreDb;
    private const string DogsCollectionPath = "Admin/AdminUserDocument/AddDog";

    public DogsController()
    {
        _firestoreDb = FirestoreDb.Create("kzn-doghouse")
    }
}