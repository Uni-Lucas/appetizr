class CategoriasController < ApplicationController
  def index
    @categorias = Categorias.all
  end
  def show
    @categoria = Categorias.find(params[:id])
  end
end
