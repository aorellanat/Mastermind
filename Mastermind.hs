{-# OPTIONS_GHC -fno-warn-tabs #-}
-- ===========================================================================
-- Proyecto Final
-- Programacion IV - Programacion Funcional
-- Departamento de Sistemas Computacionales
-- Universidad Privada Boliviana
-- Nombre: Adriana Nancy Orellana Torrico                Código = 40665
-- ===========================================================================

import System.Random
import Data.List

data Color = Rojo | Amarillo | Naranja | Rosado | Verde | Azul | Violeta | Blanco | Negro | Vacio deriving (Eq,Ord,Show)

cantidad = 4

-- Generar una lista de 4 numeros random unica
gLNumeros::Int->[Int]->[Int]
gLNumeros 0 _ = []
gLNumeros _ [] = []
gLNumeros n xs = take n . nub $ xs

-- Generador de lista de colores según una lista de números aleatorios que no contienen repetidos
gLColores::Int->[Int]->[Color]
gLColores 0 _ = []
gLColores _ [] = []
gLColores n (x:xs) = (anadirColor x):(gLColores (n - 1) xs) 

-- Elige un color según un número
anadirColor::Int->Color
anadirColor n | n == 0 = Rojo | n == 1 = Naranja | n == 2 = Amarillo | n == 3 = Rosado | n == 4 = Verde | n == 5 = Azul | otherwise = Violeta

-- Se revisa si la lista es única, de otra forma se tratará de un error
listaUnica::[Color]->Bool
listaUnica [] = True
listaUnica (x:xs) | notElem x xs = True && (listaUnica xs)
                  | otherwise = False

-- Evalua la entrada del jugador con la listaGenerada

evaluarEntrada::[Color]->[Color]->[Color]->[Color]
evaluarEntrada [] [] _ = []
evaluarEntrada [] xs _ = [Vacio|x<-xs]
evaluarEntrada (x:xs) (y:ys) zs | x == y = Blanco:(evaluarEntrada xs ys zs) 
                                | elem x zs = Negro:(evaluarEntrada xs ys zs)
                                | otherwise = Vacio:(evaluarEntrada xs ys zs)


-- Evalua si se gano el juego comparando la lista de pistas obtenidas
ganoElJuego::[Color]->Bool
ganoElJuego xs = and ([x == Blanco| x<-xs])

-- Convertir una lista de tipo caracter a Color
convertir::[Char]->[Color]
convertir xs = map (stringAColor) (separarPor " []," xs)

--Convierte un string a tipo Color
stringAColor::String->Color
stringAColor xs |  xs == "Rojo" = Rojo | xs == "Naranja" = Naranja | xs == "Amarillo" = Amarillo | xs == "Rosado" = Rosado | xs == "Verde" = Verde | xs == "Azul" = Azul | otherwise = Violeta

-- Separa una lista de caracteres dad una lista de separadores
separarPor :: Eq a => [a] -> [a] -> [[a]]
separarPor [] xs = [xs]
separarPor xs [] = []
separarPor xs l@(y:ys) | notElem y xs = (takeWhile (\x->notElem x xs) l):(separarPor xs (dropWhile (\x->notElem x xs) ys))
                       | otherwise = separarPor xs ys

-- Cantidad de turnos, en el caso del juego serán 10 turnos por palabra generada
turnos n = if n > 0 && n <= 10 then True else False

-------------------------------------------------------------------------------------------------------------------
--Entrada - salida del juego

opcionesMenu = ["1. Un jugador -> Deberas adivinar una lista de 4 colores en 10 turnos.","2. Dos jugadores -> El primer jugador ingresará una lista de 4 colores y el segundo deberá adivinar en 10 turnos.","3. Instrucciones de cómo jugar","4. Salir"]
listaColores = ["Rojo", "Amarillo", "Naranja", "Rosado", "Verde", "Azul", "Violeta"]

-- Inicio menu principal
main = do
    putStrLn "-----------------------------------------------------¡Bienvenido a Mastermind!-----------------------------------------------------"
    putStrLn $ unlines opcionesMenu
    putStrLn "¿Qué opción te gustaría jugar?"
    op <- readLn::IO Int
    case op of
        1 -> do
            putStrLn "Eligió la opción 1. ¡Vamos a comenzar!"
            nG <- generar
            let turnos = 10
            putStrLn "Ingresa una lista de 4 colores que creas correcto. Recuerda la lista debe ser única."
            modo1J nG turnos
        2-> do
            putStrLn "Eligió la opción 2. ¡Vamos a comenzar!"
            --modo2J()
        3-> do
            putStrLn "Para comenzar a jugar debes saber que las listas de 4 colores que puedes ingresar"
            putStrLn "pueden estar compuestos de los siguientes colores:"
            putStrLn $ unlines listaColores
            putStrLn "Si eliges la opcion de un jugador entonces, tendrás 10 turnos para adivinar la lista de 4 colores. Si la adivinas ganarás."
            putStrLn "Si eliges la opcion de dos jugadores entonces el primer jugador debera ingresar la palabra y el segundo debera adivinarla"
            putStrLn "Ahora si puedes comenzar, ¡Disfruta el juego!"
            main
        4-> do
            putStrLn "Vuelve pronto :)"
            return ()

-- La computadora genera una palabra y el usuario debe a divinarla
modo1J numeroGenerado t = do
                         let listaColores = gLColores cantidad numeroGenerado
                         if (t > 0 && t <= 10)
                            then do
                                  putStr "Tu respuesta: "
                                  r <- getLine
                                  let respuesta = convertir (r)
                                  if (listaUnica respuesta) 
                                      then do
                                          let concurrencias = (evaluarEntrada respuesta listaColores listaColores)
                                          if(ganoElJuego concurrencias) 
                                              then do
                                                  putStrLn "¡Felicidades!, ganaste el juego :D"
                                          else do
                                              putStrLn "Ingresa nuevamente una lista de palabras"
                                              putStr "Pista: "
                                              print concurrencias
                                              modo1J numeroGenerado (t - 1)
                                  else do
                                      putStrLn "Datos ingresados incorrectamente, asegurate que la lista solo contenga los colores establecidos en el juego."
                                      modo1J numeroGenerado t
                         else do
                            putStrLn "Lo sentimos, perdiste :("
                            putStr "La respuesta era: "
                            print listaColores

-- modo2Jugadores: El primer jugador ingresa la palabra y el otro debe adivinarla
--modo2j


-- Genera una lista de 4 elementos unicos
generar :: IO [Int]
generar = do
      g <- newStdGen
      let numeros = (randomRs (0,6) g :: [Int])
      return (gLNumeros cantidad numeros)





