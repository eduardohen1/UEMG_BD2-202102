using MongoDB.Driver;
using MongoDB.Bson;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace InventarioTIMongoDB
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
            //Código para listar os BDs disponíveis no MongoDB:
            IMongoClient cliente = new MongoClient("mongodb://localhost:27017");
            var dbList = cliente.ListDatabaseNames().ToList();
            foreach(var db in dbList)
            {
                if (textBox1.Text.Trim().Length > 0)
                    textBox1.Text += "\r\n";
                textBox1.Text += db.ToString();
            }
            */
            IMongoClient cliente = new MongoClient("mongodb://localhost:27017");
            IMongoDatabase dataBase = cliente.GetDatabase("local");
            var agenda = dataBase.GetCollection<BsonDocument>("inventario");
            var documentos = agenda.Find(new BsonDocument()).ToList();
            foreach(BsonDocument doc in documentos)
            {
                if (textBox1.Text.Trim().Length > 0)
                    textBox1.Text += "\r\n";
                textBox1.Text += doc.ToString();
            }

        }

        private void button2_Click(object sender, EventArgs e)
        {
            Inventario inventario = new Inventario();
            inventario.Equipamento = txtEquipamento.Text.Trim();
            inventario.Lotacao = txtLotacao.Text.Trim();
            inventario.NumSerie = txtNumSerie.Text.Trim();

            IMongoClient cliente = new MongoClient("mongodb://localhost:27017");
            IMongoDatabase dataBase = cliente.GetDatabase("local");
            IMongoCollection<Inventario> collection =
                    dataBase.GetCollection<Inventario>("inventario");
            collection.InsertOne(inventario);

            MessageBox.Show("Dados inseridos com sucesso!");
            txtEquipamento.Clear();
            txtLotacao.Clear();
            txtNumSerie.Clear();

        }
    }
}
