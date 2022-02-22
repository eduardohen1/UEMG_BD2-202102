using MongoDB.Bson;
using MongoDB.Driver;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace ConexaoMongoBD
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            /*
            //Listar os BDs disponíveis no MongoDB:
            IMongoClient cliente = new MongoClient("mongodb://localhost:27017");
            var dbList = cliente.ListDatabaseNames().ToList();
            foreach(var db in dbList)
            {
                if (txtResume.Text.Trim().Length > 0) txtResume.Text += "\r\n";
                txtResume.Text += db.ToString();
            }
            */
            IMongoClient cliente = new MongoClient("mongodb://localhost:27017");
            IMongoDatabase dataBase = cliente.GetDatabase("local");

            var agenda = dataBase.GetCollection<BsonDocument>("agenda");
            var documentos = agenda.Find(new BsonDocument()).ToList();
            foreach(BsonDocument doc in documentos)
            {
                if (txtResume.Text.Trim().Length > 0) txtResume.Text += "\r\n";
                txtResume.Text += doc.ToString();
            }
        }

        private void button2_Click(object sender, EventArgs e)
        {
            Cidades cidade = new Cidades();
            cidade.nome = txtCidade.Text.Trim();
            cidade.estado = txtEstado.Text.Trim();

            //gravar no BD:
            IMongoClient cliente = new MongoClient("mongodb://localhost:27017");
            IMongoDatabase dataBase = cliente.GetDatabase("local");
            IMongoCollection<Cidades> collection = dataBase.GetCollection<Cidades>("cidades");
            collection.InsertOne(cidade);

        }
    }
}
