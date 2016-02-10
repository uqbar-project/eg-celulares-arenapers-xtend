package ar.edu.celularesPers.runnable

import ar.edu.celularesPers.domain.Celular
import ar.edu.celularesPers.domain.ModeloCelular
import ar.edu.celularesPers.repos.RepoCelulares
import ar.edu.celularesPers.repos.RepoModelos
import ar.edu.celularesPers.ui.BuscarCelularesWindow
import org.uqbar.arena.Application
import org.uqbar.commons.utils.ApplicationContext
import uqbar.arena.persistence.Configuration

class CelularApplication extends Application {
	
	new(CelularesBootstrap bootstrap) {
		super(bootstrap)
	}
	
	static def void main(String[] args) { 
		Configuration.configure()
		ApplicationContext.instance.configureSingleton(typeof(ModeloCelular), new RepoModelos)
		ApplicationContext.instance.configureSingleton(typeof(Celular), new RepoCelulares)
		new CelularApplication(new CelularesBootstrap).start()
	}

	override createMainWindow() {
		return new BuscarCelularesWindow(this)
	}
	
}
