package org.example.webimc.util;

public class IMCCalculator {
    public static double calcularIMC(int peso, double altura)
    {
        double imc;
        imc=peso/Math.pow(altura,2);
        return imc;
    }
    public static String getCondicaoFisica(double imc) {
        String condicao = "Abaixo do Normal";
        if (imc > 18.6) {
            if (imc <= 25)
                condicao = "Normal";
            else if (imc < 30)
                condicao = "Sobrepeso";
            else
                condicao = "Obesidade";
        }
        return condicao;
    }
}
