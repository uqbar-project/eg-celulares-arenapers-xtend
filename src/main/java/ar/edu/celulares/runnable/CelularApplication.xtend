package ar.edu.celulares.runnable

import ar.edu.celulares.domain.Celular
import ar.edu.celulares.domain.ModeloCelular
import ar.edu.celulares.ui.BuscarCelularesWindow
import org.uqbar.arena.Application
import org.uqbar.commons.utils.ApplicationContext
import uqbar.arena.persistence.Configuration
import ar.edu.celulares.repos.RepoCelulares
import ar.edu.celulares.repos.RepoModelos

class CelularApplication extends Application {
	
	static def void main(String[] args) { 
		new CelularApplication().start()
	}

	override createMainWindow() {
		Configuration.configure()
		ApplicationContext.instance.configureSingleton(typeof(ModeloCelular), new RepoModelos)
		ApplicationContext.instance.configureSingleton(typeof(Celular), new RepoCelulares)
		return new BuscarCelularesWindow(this)
	}
	
}
