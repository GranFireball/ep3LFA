require 'raabro'
# documentação: https://github.com/floraison/raabro

module Reconhecedor include Raabro
  def parentesesComeco(i); rex(:parentesesComeco, i, /\(\s*/); end
  def parentesesFinal(i); rex(:parentesesFinal, i, /\)\s*/); end
  def elevado(i); rex(:elevado, i, /\^\s*/); end
  def multi(i); rex(:multi, i, /\*\s*/); end
  def div(i); rex(:div, i, /\/\s*/); end
  def menos(i); rex(:menos, i, /\-\s*/); end
  def mais(i); rex(:mais, i, /\+\s*/); end
  def num(i); rex(:num, i, /[0-9]+\s*/); end

  def negativo(i); seq(:negativo, i, :menos, :expressaoNumerico); end

  def exp_parenteses(i); seq(:exp_parenteses, i, :parentesesComeco, :expressaoNumerico, :parentesesFinal); end
  
  def exponenciacao(i); seq(:exponenciacao, i, :expressaoNumerico, :elevado, :expressaoNumerico); end
  def multiplicacao(i); seq(:multiplicacao, i, :expressaoNumerico, :multi, :expressaoNumerico); end
  def divisao(i); seq(:divisao, i, :expressaoNumerico, :div, :expressaoNumerico); end
  def soma(i); seq(:soma, i, :expressaoNumerico, :mais, :expressaoNumerico); end
  def subtracao(i); seq(:subtracao, i, :expressaoNumerico, :menos, :expressaoNumerico); end

  #Gramática

  def expressaoNumerico(i); alt(:expressaoNumerico, i, :exp_parenteses, :n); end
  
  def n(i); alt(:n, i, :negativo, :num); end
  
  # rewrites
  def rewrite_num(t)
    t.string
  end

  def rewrite_mais(t)
    "'Soma'"
  end

  def rewrite_menos(t)
    "'menos'"
  end

  def rewrite_multi(t)
    "'multiplicacao'"
  end

  def rewrite_div(t)
    "divisao"
  end

  def rewrite_elevado(t)
    "potencia"
  end

  def rewrite_parentesesComeco(t)
    "parenteses"
  end

  def rewrite_parentesesFinal(t)
    "parenteses"
  end

  def rewrite_negativo(t)
    folhas = t.children
    folhas.collect { |e| rewrite(e) }.append("Recohecido NEGATIVO")
  end
  
  def rewrite_soma(t)
    folhas = t.children
    folhas.collect { |e| rewrite(e) }.append("Recohecido SOMA")
  end

  def rewrite_subtracao(t)
    folhas = t.children
    folhas.collect { |e| rewrite(e) }.append("Recohecido SUBTRACAO")
  end

  def rewrite_multiplicacao(t)
    folhas = t.children
    folhas.collect { |e| rewrite(e) }.append("Recohecido MULTIPLICACAO")
  end

  def rewrite_divisao(t)
    folhas = t.children
    folhas.collect { |e| rewrite(e) }.append("Recohecido DIVISAO")
  end

  def rewrite_exponenciacao(t)
    folhas = t.children
    folhas.collect { |e| rewrite(e) }.append("Recohecido EXPONENCIACAO")
  end

  def rewrite_exp_parenteses(t)
    folhas = t.children
    folhas.collect { |e| rewrite(e) }.append("Recohecido expressaoNumerico COM PARENTESES")
  end

  def rewrite_N(t)
    folhas = t.children
    folhas.collect { |e| rewrite(e) }.append("Recohecido N")
  end
  
  def rewrite_expressaoNumerico(t)
    folhas = t.children
    folhas.collect { |e| rewrite(e) }.append("Recohecido EXPRESSAO")
  end
  
end

#puts Somador.parse("(5)")
puts Reconhecedor.parse("(-6)")
#puts Reconhecedor.parse("1 ^ 4")
#puts Somador.parse("1")
#puts Somador.parse("--1")
#puts Somador.parse("-(--1+1)")
