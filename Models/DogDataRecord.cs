using System;

namespace DogHouseAPI.Models
{
    public class DogDataRecord
    {
        public string DocumentId {get; set;}
        public string Name {get; set;}
        public string Breed {get; set;}
        public string Sex {get; set;}
        public string Bio {get; set;}

        //From Firestore
        public int Age {get; set;}
        public bool IsVaccinated {get; set;}
        public bool IsSterilized {get; set;}
        public string Status {get; set;}
        public string ImageUrl {get; set;}
        public DateTime? DateAdded {get; set;}
    }
}