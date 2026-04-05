/*
 Membros: 
 Felipe da Veiga Gomes - Luz RGB(Tipo Comando, Controlavel e Extension Controlavel)
 Rogerio de Abreu - Termostato
 Alex Narok Stavasz - CameraSeguranca + mutating + ajustes
 Logan Ail Bernardes Borges - Central de Controle, Loop da casa, Comandos finais, Filtro por ambiente e integração

  Divisão de tarefas:
 - Felipe: Enum TipoComando, Protocolo Controlavel e Extension verificarConexao()
 - Rogerio: Struct Termostato
 - Alex: Struct CameraSeguranca, implementação do desafio mutating e ajustes no protocolo
 - Logan: Central de Controle, Loop da casa, Comandos finais, Filtro por ambiente e integração geral do sistema

 Parte desenvolvida:
 - Enum TipoComando
 - Protocolo Controlavel
 - Extension verificarConexao()
 - Struct LuzRGB
 - Struct Termostato
 - Struct CameraSeguranca
 - Implementação do desafio mutating
 - Ajustes no protocolo
 - Central de Controle
 - Loop da casa
 - Comandos finais (Azul e 22)
 - Filtro por ambiente
 - Integração geral do sistema

 --------------------------------------------------------------------------------------

 Sobre Escalabilidade (Protocol Extensions):
 O uso de Protocol Extension permite que todos os dispositivos que implementam o protocolo
 Controlavel já tenham automaticamente um comportamento padrão para o método verificarConexao().
 Isso evita repetição de código e facilita a manutenção e expansão do sistema.

 ----------------------------------------------------------------------------------------

 Sobre Prioridade de Execução (Sobrescrita em POP):
 Quando utilizamos Protocol Extension, podemos fornecer implementações padrão.
 Porém, se uma struct implementar o mesmo método, o Swift dá prioridade para a implementação da struct.

 ------------------------------------------------------------------------------------------

 Sobre Structs e mutating:
 Structs são tipos por valor. Para alterar seu estado interno, usamos mutating,
 garantindo segurança e clareza na modificação.

 ----------------------------------------------------------------------------------------

 Sobre Arrays e Polimorfismo:
 O array [any Controlavel] permite armazenar diferentes structs que seguem o mesmo protocolo.
 O Swift trata todos como Controlavel, permitindo polimorfismo.

 ----------------------------------------------------------------------------------------

 Sobre Arquitetura (POP vs OOP):
 Protocolos permitem maior flexibilidade, reutilização e baixo acoplamento,
 facilitando a escalabilidade do sistema.

*/

// 1. Modelo de Comandos

enum TipoComando {
    case ligar
    case desligar
    case ajustar
}

// 2. Protocolo

protocol Controlavel {
    var nome: String { get set }
    var ambiente: String { get set }
    var estaLigado: Bool { get set }
    
    func processarComando(tipo: TipoComando, valor: String?)
    mutating func alterarEstado()
}

// 3. Extension

extension Controlavel {
    func verificarConexao() {
        print("\(nome) localizado em \(ambiente): Sinal Wi-Fi Estável")
    }
}

// 4. Dispositivos

struct LuzRGB: Controlavel {
    var nome: String
    var ambiente: String
    var estaLigado: Bool = false

    mutating func alterarEstado() {
        estaLigado.toggle()
    }
    
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
            print("\(nome) na \(ambiente) mudou para: \(valor)")
        }
    }
}

struct Termostato: Controlavel {
    var nome: String
    var ambiente: String
    var estaLigado: Bool = false

    mutating func alterarEstado() {
        estaLigado.toggle()
    }
    
    func processarComando(tipo: TipoComando, valor: String? = nil) {
        switch tipo {
        case .ligar:
            print("\(nome) na \(ambiente) ligado. Temperatura: \(valor ?? "Padrão")")
        case .desligar:
            print("\(nome) na \(ambiente) desligado.")
        case .ajustar:
            guard let valor = valor, !valor.isEmpty else {
                print("Informe temperatura.")
                return
            }
            print("\(nome) ajustado para \(valor)")
        }
    }
}

struct CameraSeguranca: Controlavel {
    var nome: String
    var ambiente: String
    var estaLigado: Bool = false
    
    mutating func alterarEstado() {
        estaLigado.toggle()
    }
    
    func processarComando(tipo: TipoComando, valor: String? = nil) {
        switch tipo {
        case .ligar:
            print("Câmera \(nome) ativada (\(valor ?? "Padrão"))")
        case .desligar:
            print("Câmera \(nome) desligada.")
        case .ajustar:
            guard let valor = valor, !valor.isEmpty else {
                print("Informe parâmetro.")
                return
            }
            print("Câmera ajustada para \(valor)")
        }
    }

    func verificarConexao() {
        print("CÂMERA \(nome): Conexão segura ativa")
    }
}

// 5. Central

var luzSala = LuzRGB(nome: "Luz Principal", ambiente: "Sala")
var ar = Termostato(nome: "Ar Condicionado", ambiente: "Quarto")
var cam = CameraSeguranca(nome: "Frontal", ambiente: "Garagem")

var rede: [any Controlavel] = [luzSala, ar, cam]

// 6. Loop

print("\n=== SISTEMA ===\n")

for i in 0..<rede.count {
    rede[i].verificarConexao()
    rede[i].processarComando(tipo: .ligar, valor: "Padrão")
}

// 7. Comandos

print("\n=== AJUSTES ===\n")

luzSala.processarComando(tipo: .ajustar, valor: "Azul")
ar.processarComando(tipo: .ajustar, valor: "22")

// 8. Filtro

print("\n=== SALA ===\n")

let sala = rede.filter { $0.ambiente == "Sala" }

for d in sala {
    d.verificarConexao()
}

// 9. Estado

print("\n=== ESTADO ===\n")

luzSala.alterarEstado()
ar.alterarEstado()
cam.alterarEstado()

print(luzSala.estaLigado)
print(ar.estaLigado)
print(cam.estaLigado)

print("\n=== EXECUÇÃO FINALIZADA COM SUCESSO ===")