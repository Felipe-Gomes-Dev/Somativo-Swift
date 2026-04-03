/*
 Membros: Felipe da Veiga Gomes - Luz RGB(Tipo Comando, Controlavel e Extension Controlavel)

 Parte desenvolvida:
 - Enum TipoComando
 - Protocolo Controlavel
 - Extension verificarConexao()
 - Struct LuzRGB

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

// Teste LuzRGB
let luzSala = LuzRGB(nome: "Luz Principal", ambiente: "Sala")

luzSala.verificarConexao()
luzSala.processarComando(tipo: .ligar)
luzSala.processarComando(tipo: .ajustar, valor: "Azul")
luzSala.processarComando(tipo: .desligar)

