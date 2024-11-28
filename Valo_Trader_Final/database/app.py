from flask import Flask, render_template, request, redirect, url_for, session
import psycopg2
from werkzeug.security import generate_password_hash, check_password_hash

app = Flask(__name__)
app.secret_key = "tu_clave_secreta"  

# Configuración de la base de datos valo_UR
DB_HOST = "localhost"
DB_NAME = "valo_trader_UR"  
DB_USER = "postgres"  
DB_PASS = "123456789"  
DB_PORT = 5433  

def obtener_conexion():
    conn = psycopg2.connect(host=DB_HOST, database=DB_NAME, user=DB_USER, password=DB_PASS, port=DB_PORT)
    return conn

@app.route("/")
def index():
    if 'usuario_id' in session:
       
        conn = obtener_conexion()
        cur = conn.cursor()
        cur.execute("SELECT * FROM Usuarios WHERE id = %s", (session['usuario_id'],))
        usuario = cur.fetchone()
        cur.execute("SELECT a.nombre_arma, i.cantidad FROM Inventarios i JOIN Armas a ON i.arma_id = a.id WHERE i.usuario_id = %s", (session['usuario_id'],))
        inventario = cur.fetchall()
        cur.close()
        conn.close()
        return render_template("index.html", usuario=usuario, inventario=inventario)
    else:
        return render_template("index.html")

@app.route("/registrar", methods=["POST"])
def registrar():
    nombre_usuario = request.form["nombre_usuario"]
    contrasena = request.form["contrasena"]
    correo = request.form["correo"]
    contrasena_hash = generate_password_hash(contrasena)

    conn = obtener_conexion()
    cur = conn.cursor()
    try:
        cur.execute("SELECT registrar_usuario(%s, %s, %s)", (nombre_usuario, contrasena_hash, correo))
        conn.commit()
        return redirect(url_for('index'))
    except Exception as e:
        return f"Error al registrar usuario: {e}"
    finally:
        cur.close()
        conn.close()

@app.route("/iniciar_sesion", methods=["POST"])
def iniciar_sesion():
    nombre_usuario = request.form["nombre_usuario"]
    contrasena = request.form["contrasena"]

    conn = obtener_conexion()
    cur = conn.cursor()
    try:
        cur.execute("SELECT * FROM Usuarios WHERE nombre_usuario = %s", (nombre_usuario,))
        usuario = cur.fetchone()
        if usuario and usuario[2] == contrasena:  # Compara en texto plano
            session['usuario_id'] = usuario[0]
            return redirect(url_for('index'))
        else:
            return "Nombre de usuario o contraseña incorrectos"
 
    except Exception as e:
        return f"Error al iniciar sesión: {e}"
    finally:
        cur.close()
        conn.close()

@app.route("/transferir", methods=["POST"])
def transferir():
    usuario_origen_id = session['usuario_id']
    usuario_destino_id = request.form["usuario_destino_id"]
    arma_id = request.form["arma_id"]
    cantidad = int(request.form["cantidad"])

    conn = obtener_conexion()
    cur = conn.cursor()
    try:
        cur.execute("SELECT transferir_arma_db(%s, %s, %s, %s)", (usuario_origen_id, usuario_destino_id, arma_id, cantidad))
        conn.commit()
        return redirect(url_for('index'))
    except Exception as e:
        return f"Error al transferir arma: {e}"
    finally:
        cur.close()
        conn.close()

@app.route("/reembolsar", methods=["POST"])
def reembolsar():
    usuario_id = session['usuario_id']
    arma_id = request.form["arma_id"]
    cantidad = int(request.form["cantidad"])

    conn = obtener_conexion()
    cur = conn.cursor()
    try:
        cur.execute("SELECT reembolsar_arma_db(%s, %s, %s)", (usuario_id, arma_id, cantidad))
        conn.commit()
        return redirect(url_for('index'))
    except Exception as e:
        return f"Error al reembolsar arma: {e}"
    finally:
        cur.close()
        conn.close()

@app.route("/devolver", methods=["POST"])
def devolver():
    usuario_id = session['usuario_id']
    arma_id = request.form["arma_id"]
    cantidad = int(request.form["cantidad"])

    conn = obtener_conexion()
    cur = conn.cursor()
    try:
        cur.execute("SELECT devolver_arma_db(%s, %s, %s)", (usuario_id, arma_id, cantidad))
        conn.commit()
        return redirect(url_for('index'))
    except Exception as e:
        return f"Error al devolver arma: {e}"
    finally:
        cur.close()
        conn.close()

@app.route("/referir", methods=["POST"])
def referir():
    usuario_id = session['usuario_id']
    referido_id = request.form["referido_id"]

    conn = obtener_conexion()
    cur = conn.cursor()
    try:
        cur.execute("SELECT referir_amigo_db(%s, %s)", (usuario_id, referido_id))
        conn.commit()
        return redirect(url_for('index'))
    except Exception as e:
        return f"Error al referir amigo: {e}"
    finally:
        cur.close()
        conn.close()

@app.route("/cerrar_sesion")
def cerrar_sesion():
    session.pop('usuario_id', None)
    return redirect(url_for('index'))

if __name__ == "__main__":
    app.run(debug=True)
