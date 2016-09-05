# Trabalho 01 - Linguagem Kotlin

## Introdução

Kotlin é uma linguagem de programação de código aberto (open source), desenvolvida pela JetBrains, que roda em uma JVM (Máquina virtual Java) e que também pode ser traduzida para JavaScript. Kotlin foi projetada para ser interoperável com o código Java, apesar das sintaxes não serem compatíveis.

## Origens e Influências

Em 2011, a JetBrains lançou o projeto Kotlin. A empresa alegava que a maioria das linguagens de programação não tinham as características procuradas por eles, com exceção da linguagem "Scala". Porém, a linguagem Scala tinha uma deficiência evidente: seu tempo de compilação. Um dos objetivos principais do Kotlin era compilar tão rápido quanto Java.

Kotlin foi lançado oficialmente em 15 de fevereiro de 2016.

## Classificação

Kotlin é uma linguagem compilada e de paradigmas: imperativa, funcional e orientada a objetos.

Kotlin possui tipagem forte, estática e inferida.

## Avaliação Comparativa

#### Leitura
Semelhante ao que acontece em Java, a leitura dos programas se torna mais díficil, por possuir muitas classes, bibliotecas e paradigmas diferentes.

#### Escrita
Também semelhante ao que acontece em Java, a esrita é dinâmica e mais fácil de ser desenvolvida. A tipagem forte e inferida contribui para um código mais curto e mais fácil de se escrever.

#### Expressividade
Kotlin possui alto poder de expressão. O principal diferencial de Kotlin é que esta linguagem diferencia variáveis nulas e não-nulas. Todos os objetos nulos devem ser declarados com um "?" logo após o nome do seu tipo de dado. Operações em objetos nulos precisam de cuidado especial dos programadores. Pensando nisso, Kotlin fornece duas operações que deixam os programadores seguros ao trabalhar com objetos nulos.

#####-> Operador ?.
Exemplo:

    bob?.departamento?.chefe?.nome
    /* retorna o nome do chefe do departamento de Bob, caso Bob esteja em algum departamento
    e caso esse departamento tenha algum chefe */

#####-> Operador ?:
Exemplo:

    fun sayHello(maybe : String?, neverNull : Int) {
      val name : String = maybe ?: "stranger"
      println("Hello $name")
    }
    // retorna "Hello stranger", se a variável maybe for nula

## Conclusão

Percebemos que Kotlin foi projetada para ser uma linguagem orientada a objetos de força industrial e para ser uma linguagem melhor do que Java, mas sendo interoperável com o código Java, permitindo que as empresas façam uma migração de Java para Kotlin.

### Bibliografia

* Wikipedia: https://en.wikipedia.org/wiki/Kotlin_(programming_language)
* Site oficial: http://kotlinlang.org/
