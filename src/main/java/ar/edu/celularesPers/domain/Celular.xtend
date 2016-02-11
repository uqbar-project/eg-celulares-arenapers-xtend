package ar.edu.celularesPers.domain

import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.commons.model.Entity
import org.uqbar.commons.model.UserException
import org.uqbar.commons.utils.Dependencies
import org.uqbar.commons.utils.TransactionalAndObservable
import uqbar.arena.persistence.annotations.PersistentClass
import uqbar.arena.persistence.annotations.PersistentField
import uqbar.arena.persistence.annotations.Relation

@TransactionalAndObservable
@PersistentClass
@Accessors
class Celular extends Entity implements Cloneable {

	final int MAX_NUMERO = 100000

	@PersistentField Integer numero
	@PersistentField String nombre
	@Relation ModeloCelular modeloCelular
	@PersistentField Boolean recibeResumenCuenta // no inicializar

	// ********************************************************
	// ** Getters y setters
	// Los getters y setters por default no se deben codificar
	// peeeeeero...
	// en nuestro ejemplo tenemos que modificar la propiedad
	// recibeResumenCuenta en base al modelo de celular seleccionado
	// ********************************************************
	def void setNumero(Integer unNumero) {
		if (unNumero != null && unNumero.intValue() <= this.MAX_NUMERO) {
			throw new UserException("El número debe ser mayor a " + this.MAX_NUMERO)
		}
		this.numero = unNumero
	}

	def void setModeloCelular(ModeloCelular unModeloCelular) {
		modeloCelular = unModeloCelular
		recibeResumenCuenta = unModeloCelular.requiereResumenCuenta
	}

	// ********************************************************
	// ** Validacion
	// ********************************************************
	/**
	 * Valida que el celular esté correctamente cargado (cumple todas las validaciones que plantea el negocio)
	 */
	def validar() {
		if (numero == null) {
			throw new UserException("Debe ingresar número")
		}
		if (numero.intValue() <= this.MAX_NUMERO) {
			throw new UserException("El número debe ser mayor a " + this.MAX_NUMERO)
		}
		if (!this.ingresoNombre()) {
			throw new UserException("Debe ingresar nombre")
		}
		if (modeloCelular == null) {
			throw new UserException("Debe ingresar un modelo de celular")
		}
	}

	def ingresoNombre() {
		nombre != null && !nombre.trim().equals("")
	}

	// ********************************************************
	// ** Propiedades adicionales
	// ********************************************************
	/**
	 * Determina cuándo es correcto que se pueda determinar 
	 * si el cliente recibe el resumen de cuenta en su domicilio
	 * @return un booleano
	 */
	@Dependencies("modeloCelular")
	def getHabilitaResumenCuenta() {
		!modeloCelular.requiereResumenCuenta
	}

	// ********************************************************
	// ** Cómo se muestra el cliente de un celular
	// ********************************************************
	override def String toString() {
		var result = new StringBuffer
		result.append(nombre ?: "Celular sin nombre")
		if (modeloCelular != null) {
			result.append(" - " + modeloCelular)
		}
		if (numero != null) {
			result.append(" - " + numero)
		}
		result.append(descripcionRecibeResumen)
		result.toString
	}
	
	def getDescripcionRecibeResumen() {
		if (recibeResumenCuenta == null) {
			return " - no configurado si recibe resumen"
		}
		if (recibeResumenCuenta) " - recibe resumen" else " - no recibe resumen"
	}

	// ********************************************************
	// ** Manejo de copias
	// ********************************************************
	override clone() {
		super.clone()
	}

	def copiarA(Celular destino) {
		destino.numero = this.numero
		destino.nombre = this.nombre
		destino.recibeResumenCuenta = this.recibeResumenCuenta
		destino.modeloCelular = this.modeloCelular
	}

}
