using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;
using System;
using System.ComponentModel.DataAnnotations;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InventarioTIMongoDB
{
    public class Inventario
    {
        [BsonRepresentation(BsonType.ObjectId)]
        public String Id { get; set; }

        [Display(Name = "equipamento")]
        [BsonElement("equipamento")]
        public String Equipamento { get; set; }
        
        [Display(Name = "lotacao")]
        [BsonElement("lotacao")]
        public String Lotacao { get; set; }
        
        [Display(Name = "numserie")]
        [BsonElement("numserie")]
        public String NumSerie { get; set; }
    }
}
