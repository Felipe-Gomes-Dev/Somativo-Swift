/*
 Membros: Felipe da Veiga Gomes - Luz RGB(Tipo Comando, Controlavel e Extension Controlavel)
 Rogerio de Abreu - Termostato

 Parte desenvolvida:
 - Enum TipoComando
 - Protocolo Controlavel
 - Extension verificarConexao()
 - Struct LuzRGB
 - Struct Termostato

*/
//1. Modelo de Comandos
enum TipoComando {
    case ligar
    case desligar
    case ajustar
}

// 2. Criando Protocolo Controlavel
protocol Controlavel {
    var nome: String { get set }
    var ambiente: String { get set }
    
    func processarComando(tipo: TipoComando, valor: String?)
}

// 3. Extension
extension Controlavel {
    func verificarConexao() {
        print("\(nome) localizado em \(ambiente): Sinal Wi-Fi Estável 📶")
    }
}

// Struct da Luz
struct LuzRGB: Controlavel {
    var nome: String
    var ambiente: String
    
    func processarComando(tipo: TipoComando, valor: String? = nil) {
        switch tipo {
        case .ligar:
            print("\(nome) na \(ambiente) foi ligada.")
        case .desligar:
            print("\(nome) na \(ambiente) foi desligada.")
        case .ajustar:
            guard let valor = valor, !valor.isEmpty else {
                print("Informe um valor para ajuste.")
                return
            }
            print("💡 \(nome) na \(ambiente) mudou a cor/brilho para: \(valor)")
            
        }
    }
}

// Struct do Termostato
struct Termostato: Controlavel {
    var nome: String
    var ambiente: String
    
    func processarComando(tipo: TipoComando, valor: String? = nil) {
        switch tipo {
        case .ligar:
            print("❄️ \(nome) na \(ambiente) recebeu comando ligar. Temperatura alvo: \(valor ?? "Padrão") graus")
        case .desligar:
            print("❄️ \(nome) na \(ambiente) foi desligado.")
        case .ajustar:
            guard let valor = valor, !valor.isEmpty else {
                print("Informe uma temperatura para ajuste.")
                return
            }
            print("❄️ \(nome) na \(ambiente) ajustou a temperatura para: \(valor) graus")
        }
    }
}

// Teste LuzRGB
let luzSala = LuzRGB(nome: "Luz Principal", ambiente: "Sala")

luzSala.verificarConexao()
luzSala.processarComando(tipo: .ligar)
luzSala.processarComando(tipo: .ajustar, valor: "Azul")
luzSala.processarComando(tipo: .desligar)

// Teste Termostato
let arCondicionadoQuarto = Termostato(nome: "Ar Condicionado", ambiente: "Quarto")

arCondicionadoQuarto.verificarConexao()
arCondicionadoQuarto.processarComando(tipo: .ligar, valor: "Padrão")
arCondicionadoQuarto.processarComando(tipo: .ajustar, valor: "22")
arCondicionadoQuarto.processarComando(tipo: .desligar)

