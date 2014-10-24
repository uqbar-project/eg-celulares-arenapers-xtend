package ar.edu.celulares.applicationModel

import java.io.Serializable
import java.util.List
import ar.edu.celulares.domain.Celular
import org.uqbar.commons.utils.ApplicationContext
import java.util.ArrayList
import ar.edu.celulares.repos.RepoCelulares

/**
 * Application model que representa la búsqueda de {@link Celular}.
 * Contiene:
 * <ul>
 * 	<li>El estado de los atributos por los cuales buscar: numero y nombre</li>
 *  <li>El comportamiento para realizar la búsqueda (en realidad delega en otros objetos)</li>
 *  <li>El estado del resultado de la búsqueda, es decir que recuerda la lista de Celulares resultado</li>
 *  <li>El estado de la selección de un Celular para poder utilizar el comportamiento que sigue...</li>
 *  <li>Comportamiento para eliminar un Celular seleccionado.</li>
 * </ul>
 *
 * Este es un objeto transiente, que contiene estado de la ejecución para un usuario en particular
 * en una ejecución de la aplicación en particular.
 *
 * @author npasserini
 */
@org.uqbar.commons.utils.Observable
class BuscadorCelular implements Serializable {

	@Property Integer numero
	@Property String nombre
	@Property List<Celular> resultados
	@Property Celular celularSeleccionado

	// ********************************************************
	// ** Acciones
	// ********************************************************
	def void search() { 
		// WORKAROUND para que refresque la grilla en las actualizaciones
		resultados = new ArrayList<Celular>

		// FIN WORKAROUND
		resultados = repoCelulares.search(numero, nombre)
		// también se puede llamar getRepoCelulares().search(numero, nombre) 
	}

	def void clear() {
		nombre = null
		numero = null
	}

	def void eliminarCelularSeleccionado() {
		repoCelulares.delete(celularSeleccionado)
		this.search
		celularSeleccionado = null
	}

	def RepoCelulares getRepoCelulares() {
		ApplicationContext.instance.getSingleton(typeof(Celular))
	}

}
