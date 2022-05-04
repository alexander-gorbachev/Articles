struct ApplicationAssembly {
    static func assembly() {
        ServicesAssembly().assembly()
        FacadesAssembly().assembly()
    }
}
