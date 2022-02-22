using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ConexaoMongoBD
{
    public class Cidades
    {
        [BsonRepresentation(BsonType.ObjectId)]
        public String Id { get; set; }
        
        [Display(Name = "nome")]
        [BsonElement("nome")]
        public String nome { get; set; }

        [Display(Name = "estado")]
        [BsonElement("estado")]
        public String estado { get; set; }

    }
}
