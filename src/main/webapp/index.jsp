<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8"/>
	<meta name="viewport" content="width=device-width"/>
	
	<link 
		href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" 
		rel="stylesheet" 
		integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC"
		crossorigin="anonymous">
		
	<title>Oka-y ;) JSP</title>
</head>
<body>
	<%! 
	// Declaracion de constantes.
	
	final int[][] circuito = {
		{  1,  2,  3,  4,  5,  6 },
		{ 20, 21, 22, 23, 24,  7 },
		{ 19, 32, 33, 34, 25,  8 },
		{ 18, 31, 36, 35, 26,  9 },
		{ 17, 30, 29, 28, 27, 10 },
		{ 16, 15, 14, 13, 12, 11 }
	};

	final int TURNO_AZUL = 0;
	final int TURNO_ROJO = 1;
	
	final int CASILLA_OBJETIVO = circuito.length*circuito[0].length;
	final String[] TABLERO_VERDE = { 
			"0.4", "0.8", "0.5", "#00bfff", "#ff3333", "#e600ac", "orange" 
	};
	final int SUAVIZAR_COLOR = 3;
	final int TIMEOUT_VALOR = 2000;
	
	final String[] textosAyuda = { 
			"Pieza azul", "Pieza roja", "Piezas combinadas", "Meta" 
	};
	
	
	// Declaracion de variables.
	
	int turnoActual = TURNO_AZUL;
	int posicionAzul = 1;
	int posicionRojo = 1;
	String dado = "";
	String[] datos = TABLERO_VERDE;
	%>

	<%!
	
	// Renderiza una celda en base al indice "casilla" donde
	// 1 celda podria ser: 
	// - Jugador azul
	// - Jugador rojo
	// - Ambos jugadores (morado)
	// - Meta
	// - Color degradado del tablero
	String calcularColor(int casilla) {;	
		final int aux = 255 - (casilla*255/CASILLA_OBJETIVO/SUAVIZAR_COLOR);
		final double r = aux*Double.parseDouble(datos[0]);
		final double g = aux*Double.parseDouble(datos[1]);
		final double b = aux*Double.parseDouble(datos[2]);
		final String rgb = r + "," + g + "," + b;
	
		return casilla == posicionAzul && posicionAzul == posicionRojo ? 
				datos[5] :
				casilla == posicionAzul ?
						datos[3] :
						casilla == posicionRojo ?
							datos[4] : 
							casilla == CASILLA_OBJETIVO ?
								datos[6] : "rgb(" + rgb + ")";
	}
	
	// Para ahorrar la linea cada vez que quiero comprobar
	// el turno actual.
	boolean IsTurnoAzul() {
		return turnoActual == TURNO_AZUL;
	}
	
	// Para ahorra la linea cada vez que quiero comprobar si 
	// se ha ganado.
	boolean IsVictoria() {
		return posicionAzul == CASILLA_OBJETIVO || posicionRojo == CASILLA_OBJETIVO;
	}
	
	// Devuelve un numero random (dado)
	int generarNumeroAleatorio() {
		return ((int)(Math.random()*6)) + 1;
	}
	
	// Alterna los valores de la variable turno.
	int alternarTurno() {
		return IsTurnoAzul() ? TURNO_ROJO : TURNO_AZUL;
	}
	
	// Resta casillas si la posicion actual es mayor a la casilla
	// objetivo.
	int fixPosicion(int posicion) {
		return posicion > CASILLA_OBJETIVO ? 
				CASILLA_OBJETIVO - (posicion - CASILLA_OBJETIVO) :
				posicion;
	}
	
	// Calcula el color del dado para un feedback visual.
	String comprobarColorDado() {
		return posicionAzul == CASILLA_OBJETIVO ? 
				"text-primary" :
				posicionRojo == CASILLA_OBJETIVO ? 
					"text-danger" :
					IsTurnoAzul() ? 
						"text-danger" : 
						"text-primary";
	}
	
	// Destaca casillas como el inicio y la meta para un
	// feedback visual.
	String destacarCasillasEspeciales(int x, int y) {
		int valor = circuito[x][y];
		
		return valor == 1 || valor == CASILLA_OBJETIVO ? 
				"" : 
				String.valueOf(valor);
	}
	
	// Actualiza la posicion de X pieza en base al turno actual.
	void moverPieza(int dado) {
		switch (turnoActual) {
		case TURNO_AZUL:
			posicionAzul = fixPosicion(posicionAzul + dado);
			break;
			
		case TURNO_ROJO:
			posicionRojo = fixPosicion(posicionRojo + dado);
			break;
		}
	}
	
	// Resetea los valores a por defecto a falta de un reload completo
	// de la pagina como "location.reload()"
	void resetAll() {
		posicionAzul = 1;
		posicionRojo = 1;
		turnoActual = TURNO_AZUL;
	} 
	%>
	
	<%	
	// Si se ha enviado el parametro reset es porque la partida
	// ha terminado.
	if (request.getParameter("reset") != null) resetAll();
	
	String turno = request.getParameter("turno");	
	
	// Si este parametro es null es porque la pagina se
	// ha abierto por primera vez 
	// (no dado, no movmiento, no cartel victoria)
	if (turno != null) {
		turnoActual = Integer.parseInt(turno);
		
		dado = request.getParameter("dado");
		moverPieza(Integer.parseInt(dado));
		
		if (IsVictoria()) {
			// Thread.sleep(TIMEOUT_VALOR); %>
			
			<!-- Renderiza el cartel de victoria -->
			
			<div id="cartelVictoria" class="text-center p-5">
				<h2>El jugador 
					<span class="<%=IsTurnoAzul() ? 
						"text-primary" : 
						"text-danger" %>">
						<%=IsTurnoAzul() ? "AZUL" : "ROJO" %>
					</span>
				</h2>
				<form action="/ProjectOkaJSP" method="get">
					<input
						id="reloadButton"
						class="btn btn-primary btn-lg mt-4"
						type="submit"
						value="Empezar nueva partida">
						
					<input 
						type="hidden" 
						name="reset" 
						value="1">
				</form>
			</div>
		
		<%
			// Evita que la pagina siga renderizandose 
			// (render del juego)
			return;
		} 
	} %>
	
	<!-- Renderiza el juego (tabla, boton, etc..) -->	
	<div 
		id="juego"
		class="container-fluid p-2">
		
		<h3 class="text-center mb-4">Juego de la OCA [JSP]</h3>
		
		<div
			class="mx-auto"
			style="width: fit-content;">
			
			<h5>
				Turno del jugador: 
				<span class="<%=IsTurnoAzul() ? "text-primary" : "text-danger" %>">
					<%=IsTurnoAzul() ? "Azul" : "Rojo" %>
				</span>
			</h5>	
			
			<table id="tabla" class="user-select-none my-2">
			<%
			for (int i = 0; i < circuito.length; i++) { %>
				<tr>
			<%
				for (int j = 0; j < circuito[0].length; j++) { %>
					<td
						id="<%=circuito[i][j] %>"
						style="background-color: <%=calcularColor(circuito[i][j])  %>"
						class="p-5 text-center text-white border">
						<%=destacarCasillasEspeciales(i, j) %>
					</td>
				<%
				} %>
			
				</tr> 
			<%
			} %>
			</table>
			
			<div id="controlUsuario" class="d-flex justify-content-between">
				<div class="">
					<form action="/ProjectOkaJSP" method="get">
						<input
							id="generarNumero"
							class="btn btn-primary btn-lg btn-success <%=IsVictoria() ? "disabled" : "" %>"
							type="submit" value="Tirar dado!">
						
						<input 
							type="hidden" 
							name="turno" 
							value="<%=alternarTurno()%>">
							
						<input 
							type="hidden" 
							name="dado" 
							value="<%=generarNumeroAleatorio()%>">
					</form>
					<h5 class="mt-2">
						Numero alatorio: 
						<span 
							id="numero" 
							class="px-2 <%=comprobarColorDado() %>"><%=dado %></span>
					</h5>
				</div>
				
				<div id="ayuda" class="float-end">
					<%
					for (int i = 0; i < textosAyuda.length; i++) { %>
						<div class="d-inline-flex align-items-center ms-2">
							<div
								style="background-color: <%=datos[i + 3]%>; width: 15px; height: 15px">
								
							</div>
							<div class="ms-1"><%=textosAyuda[i] %></div>
						</div>
					<%
					}
					%>
				</div>
			</div>			
		</div>
	</div>
</body>
</html>