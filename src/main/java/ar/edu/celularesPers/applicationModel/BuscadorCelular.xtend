package ar.edu.celularesPers.applicationModel

import ar.edu.celularesPers.domain.Celular
import ar.edu.celularesPers.repos.RepoCelulares
import java.io.Serializable
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.commons.utils.ApplicationContext
import org.uqbar.commons.utils.Observable

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
@Observable
@Accessors
class BuscadorCelular implements Serializable {

	Integer numero
	String nombre
	List<Celular> resultados
	Celular celularSeleccionado

	// ********************************************************
	// ** Acciones
	// ********************************************************
	def void search() { 
		resultados = repoCelulares.search(numero, nombre)
		// también se puede llamar getRepoCelulares().search(numero, nombre) 
	}

	def void clear() {
		nombre = null
		numero = null
		resultados = newArrayList
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
