from flask import Flask, render_template, request
import requests
from bs4 import BeautifulSoup

app = Flask(__name__)

class TaxGtin:
    FURL = 'https://www.systax.com.br/ean/'

    def __init__(self):
        self.descricao = ""
        self.ean = ""
        self.ncm = ""
        self.cest = ""
        self.retorno = ""

    def set_ean(self, value):
        self.ean = value

    def ncm_to_cest(self):
        url = f"http://www.buscacest.com.br/?utf8=%E2%9C%93&ncm={self.ncm}"
        try:
            response = requests.get(url)
            response.encoding = 'utf-8'
            self.subtrair_dados_cest(response.text)
        except Exception as e:
            print(f"Erro ao buscar CEST: {e}")

    def subtrair_dados(self, informacao):
        self.retorno = informacao
        if "01001345450801" in informacao:
            self.descricao = "Código de barra inválido!"
            self.ncm = ""
        else:
            self.ncm = self.retornar_conteudo_entre(informacao, "NCM:", "</a>", False)
            self.ncm = self.only_number(self.ncm)[:8]
            self.descricao = self.remover_espacos_duplos(
                self.retornar_conteudo_entre(
                    informacao,
                    '<h2 class="fonte-open-title h1-title" style="text-align:center;">',
                    '</h2>',
                    False
                )
            )
            self.ncm_to_cest()

    def subtrair_dados_cest(self, informacao):
        soup = BeautifulSoup(informacao, 'html.parser')
        rows = soup.find_all('tr')
        for i, row in enumerate(rows):
            columns = row.find_all('td', class_="text-right")
            if columns:
                self.cest = columns[0].get_text(strip=True)
                if i == 1:
                    break

    @staticmethod
    def retornar_conteudo_entre(frase, inicio, fim, inclui_inicio_fim):
        try:
            start = frase.index(inicio) + (len(inicio) if not inclui_inicio_fim else 0)
            end = frase.index(fim, start) + (len(fim) if inclui_inicio_fim else 0)
            return frase[start:end]
        except ValueError:
            return ""

    @staticmethod
    def remover_espacos_duplos(string):
        return " ".join(string.split())

    @staticmethod
    def only_number(value):
        return "".join(filter(str.isdigit, value))

    def send_get(self, endpoint):
        try:
            url = f"{self.FURL}{endpoint}"
            response = requests.get(url)
            response.encoding = 'utf-8'
            self.subtrair_dados(response.text)
            return response.status_code, response.text
        except Exception as e:
            print(f"Erro ao enviar GET: {e}")
            return None, None


@app.route("/", methods=["GET", "POST"])
def index():
    data = None
    if request.method == "POST":
        ean_code = request.form["ean"]
        tax_gtin = TaxGtin()
        tax_gtin.set_ean(ean_code)
        status_code, _ = tax_gtin.send_get(ean_code)

        if status_code == 200:
            data = {
                "descricao": tax_gtin.descricao,
                "ean": ean_code,
                "ncm": tax_gtin.ncm,
                "cest": tax_gtin.cest,
            }
        else:
            data = {"error": f"Erro ao buscar os dados. Código HTTP: {status_code}"}

    return render_template("index.html", data=data)


if __name__ == "__main__":
    app.run(debug=True)
