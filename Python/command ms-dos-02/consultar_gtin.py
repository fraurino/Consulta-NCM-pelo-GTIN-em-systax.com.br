import requests
from bs4 import BeautifulSoup
import sys

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
            end   = frase.index(fim, start) + (len(fim) if inclui_inicio_fim else 0)
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
            response.encoding = 'ANSI'
            content = response.text.encode('latin1').decode('ANSI', errors='ignore')
            self.subtrair_dados(content)
            return response.status_code, content
        except Exception as e:
            print(f"Erro ao enviar GET: {e}")
            return None, None

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Uso: python consultar_gtin.py <arquivo_barras> <arquivo_saida>")
        sys.exit(1)

    barras_file = sys.argv[1]
    output_file = sys.argv[2]

    try:
        # Lê o conteúdo do arquivo barras.txt (que contém o código EAN)
        with open(barras_file, 'r') as file:
            ean_code = file.readline().strip()  # Lê a primeira linha e remove espaços em branco
            if not ean_code:
                raise ValueError("Código de barras não encontrado no arquivo.")
    except Exception as e:
        print(f"Erro ao ler o arquivo: {e}")
        sys.exit(1)

    tax_gtin = TaxGtin()
    tax_gtin.set_ean(ean_code)

    status_code, _ = tax_gtin.send_get(ean_code)

    if status_code == 200:
        with open(output_file, "w", encoding="utf-8") as f:
            f.write(f"DESCRICAO;GTIN;NCM;CEST\n")
            f.write(f"{tax_gtin.descricao};{ean_code};{tax_gtin.ncm};{tax_gtin.cest}\n")
        print(f"Dados salvos no arquivo: {output_file}")
    else:
        print(f"Erro ao buscar os dados. Código HTTP: {status_code}")
