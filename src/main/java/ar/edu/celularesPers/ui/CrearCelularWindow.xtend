package ar.edu.celularesPers.ui

import ar.edu.celularesPers.domain.Celular
import org.uqbar.arena.windows.WindowOwner

class CrearCelularWindow extends EditarCelularWindow {
	
	new(WindowOwner owner) {
		super(owner, new Celular)
	}

}