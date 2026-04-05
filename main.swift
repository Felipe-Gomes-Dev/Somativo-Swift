/*
 Membros: 
 Felipe da Veiga Gomes - Luz RGB(Tipo Comando, Controlavel e Extension Controlavel)
 Rogerio de Abreu - Termostato
 Alex Narok Stavasz - CameraSeguranca + mutating + ajustes

  Divisão de tarefas:
 - Felipe: Enum TipoComando, Protocolo Controlavel e Extension verificarConexao()
 - Rogerio: Struct Termostato
 - Alex: Struct CameraSeguranca, implementação do desafio mutating e ajustes no protocolo

 Parte desenvolvida:
 - Enum TipoComando
 - Protocolo Controlavel
 - Extension verificarConexao()
 - Struct LuzRGB
 - Struct Termostato
 - Struct CameraSeguranca
 - Implementação do desafio mutating
 - Ajustes no protocolo

 --------------------------------------------------------------------------------------

 Sobre Escalabilidade (Protocol Extensions):
 O uso de Protocol Extension permite que todos os dispositivos que implementam o protocolo
 Controlavel já tenham automaticamente um comportamento padrão para o método verificarConexao().
 Isso evita repetição de código, pois não precisamos implementar esse método em cada struct.
 Caso novos dispositivos sejam adicionados (como smart TV ou robô aspirador),
 eles já herdarão esse comportamento automaticamente, facilitando a manutenção e escalabilidade do sistema.

 ----------------------------------------------------------------------------------------

 Sobre Prioridade de Execução (Sobrescrita em POP):
 Quando utilizamos Protocol Extension, podemos fornecer implementações padrão.
 Porém, se uma struct implementar o mesmo método, o Swift dá prioridade para a implementação da struct.
 No caso da CameraSeguranca, ela sobrescreve o método verificarConexao(),
 exibindo uma mensagem específica. Isso mostra que implementações concretas têm prioridade sobre as padrão.

 ------------------------------------------------------------------------------------------

 Sobre Structs e mutating (Desafio extra):
 Em Swift, structs são tipos por valor (value types). Isso significa que seus dados são copiados ao invés de referenciados.
 Para modificar uma propriedade interna dentro de um método, é necessário usar a palavra-chave mutating.
 Isso garante mais segurança, pois deixa explícito que o estado interno da struct será alterado.

*/
// 1. Modelo de Comandos
enum TipoComando {
    case ligar
    case desligar
    case ajustar
}

// 2. Criando Protocolo Controlavel
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
        print("\(nome) localizado em \(ambiente): Sinal Wi-Fi Estável 📶")
    }
}

// Struct da Luz
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
            print("💡 \(nome) na \(ambiente) mudou a cor/brilho para: \(valor)")
        }
    }
}

// Struct do Termostato
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

// Struct da Camera de Seguranca
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
            print("🎥 Câmera \(nome) na \(ambiente) processando: ligar (Parâmetro: \(valor ?? "Padrão"))")
        case .desligar:
            print("🎥 Câmera \(nome) na \(ambiente) foi desligada.")
        case .ajustar:
            guard let valor = valor, !valor.isEmpty else {
                print("Informe um parâmetro para a câmera.")
                return
            }
            print("🎥 Câmera \(nome) na \(ambiente) processando: ajustar (Parâmetro: \(valor))")
        }
    }

    // Sobrescrita da Extension
    func verificarConexao() {
        print("⚠️ CÂMERA \(nome) na \(ambiente): Conexão Segura e Criptografada Ativa 🔒")
    }
}

// Teste LuzRGB
var luzSala = LuzRGB(nome: "Luz Principal", ambiente: "Sala")

luzSala.verificarConexao()
luzSala.processarComando(tipo: .ligar)
luzSala.processarComando(tipo: .ajustar, valor: "Azul")
luzSala.processarComando(tipo: .desligar)
luzSala.alterarEstado()

// Teste Termostato
var arCondicionadoQuarto = Termostato(nome: "Ar Condicionado", ambiente: "Quarto")

arCondicionadoQuarto.verificarConexao()
arCondicionadoQuarto.processarComando(tipo: .ligar, valor: "Padrão")
arCondicionadoQuarto.processarComando(tipo: .ajustar, valor: "22")
arCondicionadoQuarto.processarComando(tipo: .desligar)
arCondicionadoQuarto.alterarEstado()

// Teste Camera de Seguranca
var cameraGaragem = CameraSeguranca(nome: "Frontal", ambiente: "Garagem")

cameraGaragem.verificarConexao()
cameraGaragem.processarComando(tipo: .ligar)
cameraGaragem.processarComando(tipo: .ajustar, valor: "Alta Resolução")
cameraGaragem.processarComando(tipo: .desligar)
cameraGaragem.alterarEstado()