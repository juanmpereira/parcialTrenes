class Deposito{
	var property formaciones
		var property locomotorasSueltas = []

	method agregarFormacion(formacion) {
		formaciones.add(formacion)
	}
	method agregarLocomotora(locomotora) {
		locomotorasSueltas.add(locomotora)
	}
	method quitarLocomotora(locomotora) {
		locomotorasSueltas.remove(locomotora)
	}
	method losMasPesados(){
		return formaciones.map({f=>f.elVagonMasPesado()})
	}
	method necesitaExperimentado(){
		return formaciones.any({f=>f.esCompleja()})
	}
	
	method hacerQueSeMueva(formacion){
		if(formacion.puedeMoverse().negate()&&self.hayDisponibles(formacion))
		formacion.agregarLocomotora(self.buscarLocomotoraDisponible(formacion))
	}
	
	method hayDisponibles(formacion){
		return locomotorasSueltas.any({l=>self.haceQueSeMueva(l,formacion)})
	}
	method buscarLocomotoraDisponible(formacion){
		return locomotorasSueltas.find({l=>self.haceQueSeMueva(l,formacion)})
	}
	
	method haceQueSeMueva(l,formacion){
		return	l.arrastreUtil()>=formacion.cuantoFaltaParaMoverse()
	}
}


class Formacion {
	var property vagones
	var property locomotoras
	
	method agregarLocomotoras(locomotora){
		locomotoras.add(locomotora)
	}
	
	method lleva(){
		return vagones.sum({v=>v.cantPasajeros()})
	}
	
	method rapidez(){
		return locomotoras.min({l=>l.velMax()}).velMax()
	}
	
	method vagonesLivianos(){
		return vagones.count({v=>v.peso()<2500})
	}
	
	method eficiencia(){
		return locomotoras.all({l=>l.arrastraMucho()})
	}
	
	method pesoVagones(){
		return vagones.sum({v=>v.peso()})
	}
	method pesoLocomotoras(){
		return locomotoras.sum({l=>l.peso()})
	}
	
	method totalArrastre(){
		return locomotoras.sum({l=>l.arrastreUtil()})
	}
	
	method puedeMoverse(){
		return self.totalArrastre() > self.pesoVagones()
	}
	
	method cuantoFaltaParaMoverse(){
		if(self.puedeMoverse())
		return 0
		else
		return self.pesoVagones()-self.totalArrastre()
	}
	
	method elVagonMasPesado(){
		return vagones.max({v=>v.peso()})
	}
	method masDe20Unidades(){
		return vagones.size()>20
	}
	method pesoTotalGrande(){
		return (self.pesoVagones()+self.pesoLocomotoras())>10000
	}
	method esCompleja(){
		return self.masDe20Unidades()||self.pesoTotalGrande()
	}
	
	method estaBienArmada(){
		return self.puedeMoverse() and self.bienArmadaEspecifica()
	}
	
	method bienArmadaEspecifica()
	
	method velLimite()= self.rapidez()
	method limiteReal()= self.rapidez().min(self.velLimite())
}

class CortaDist inherits Formacion{
	override method bienArmadaEspecifica(){
		return self.esCompleja().negate() 
	}
	override method velLimite()=60
}

class LargaDist inherits Formacion{
	var origen
	var destino
	
	override method bienArmadaEspecifica(){
		return vagones.sum({v=>v.banos()})>self.lleva()/50
	}
	
	method uneCiudadesGrandes(){
		return origen.esGrande() && destino.esGrande()
	}
	
	override method velLimite(){
		if(self.uneCiudadesGrandes())
		return 200
		else 
		return 150
	}
	
}

class Ciudad{
	var property esGrande = true
}

class AltaVelocidad inherits LargaDist{
	override method velLimite()=400
	override method bienArmadaEspecifica(){
		return self.vagonesLivianos() == vagones.size() && self.limiteReal()>250 && super()
	}
}

class Locomotora{
	var property peso
	var arrastre
	var property velMax
	
	method arrastreUtil(){
		return arrastre-peso
	}
	
	method arrastraMucho(){
		return self.arrastreUtil()>=5*peso
	}
}

class VagonCarga{
	var limite
	method banos()=0
	
	method peso(){
		return limite + 160
	}
	
	method cantPasajeros() = 0
}

class VagonPasajero{
	var largo
	var ancho 
	var property banos
	
	method cantPasajeros(){
		if(ancho<2.5)
		return largo*8
		else
		return largo*10
	}
	
	method peso(){
		return self.cantPasajeros()*80
	}
	
	
	
}