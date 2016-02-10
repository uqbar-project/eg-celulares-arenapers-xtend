package ar.edu.celularesPers.ui

import ar.edu.celularesPers.domain.Celular
import ar.edu.celularesPers.domain.ModeloCelular
import ar.edu.celularesPers.repos.RepoCelulares
import ar.edu.celularesPers.repos.RepoModelos
import org.uqbar.arena.bindings.ObservableProperty
import org.uqbar.arena.bindings.PropertyAdapter
import org.uqbar.arena.layout.ColumnLayout
import org.uqbar.arena.widgets.Button
import org.uqbar.arena.widgets.CheckBox
import org.uqbar.arena.widgets.Label
import org.uqbar.arena.widgets.NumericField
import org.uqbar.arena.widgets.Panel
import org.uqbar.arena.widgets.Selector
import org.uqbar.arena.widgets.TextBox
import org.uqbar.arena.windows.Dialog
import org.uqbar.arena.windows.WindowOwner
import org.uqbar.commons.utils.ApplicationContext

import static extension org.uqbar.arena.xtend.ArenaXtendExtensions.*

class EditarCelularWindow extends Dialog<Celular> {

	Celular original

	new(WindowOwner owner, Celular model) {
		super(owner, model)
		if (model.isNew) {
			title = "Nuevo celular"
		} else {
			title = "Editar datos del celular"
		}
		original = model.clone() as Celular
	}

	override protected createFormPanel(Panel mainPanel) {
		val form = new Panel(mainPanel)
		form.layout = new ColumnLayout(2)
		new Label(form).text = "Número"
		new NumericField(form) => [
			value <=> "numero"
			width = 150
		]

		new Label(form).text = "Nombre del cliente"
		new TextBox(form) => [
			value <=> "nombre"
			width = 250
		]
		new Label(form).text = "Modelo del aparato"
		new Selector<ModeloCelular>(form) => [
			allowNull = false
			value <=> "modeloCelular"
			bindItems(new ObservableProperty(repoModelos, "modelos")) => [
				it.adapter = new PropertyAdapter(typeof(ModeloCelular), "descripcionEntera")
			]
		]
		new Label(form).text = "Recibe resumen cuenta en domicilio"
		new CheckBox(form) => [
			enabled <=> "habilitaResumenCuenta"
			value <=> "recibeResumenCuenta"
		]
	}

	override protected void addActions(Panel actions) {
		new Button(actions) => [
			caption = "Aceptar"
			onClick [|
				if (modelObject.isNew) {
					println("Creo un nuevo celular")
					repoCelulares.create(modelObject)
				} else {
					println("Actualizo el celular")
					repoCelulares.update(this.modelObject)
				}
				this.accept
			]
			setAsDefault
			disableOnError
		]

		new Button(actions) => [
			caption = "Cancelar"
			onClick [|
				if (!original.isNew) {
					original.copiarA(this.modelObject)
				}
				this.cancel
			]
		]

	}

	def getRepoCelulares() {
		ApplicationContext.instance.getSingleton(typeof(Celular)) as RepoCelulares
	}

	def getRepoModelos() {
		ApplicationContext.instance.getSingleton(typeof(ModeloCelular)) as RepoModelos
	}

}
