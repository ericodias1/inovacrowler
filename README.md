# InovaCrawler

Aplicação com o propósito de trabalhar como versão **API** do site [Quotes To Scrape](http://quotes.toscrape.com).

Desenvolvido com as tecnologias [Ruby on Rails](https://rubyonrails.org/), [
Mongo DB](https://www.mongodb.com/) e utilizando o conceito de Web Crawlers.

# Como utilizar?

Acessando a URL `/quotes/:search_tag` com o token de autorização `0x3f01b98dce38ab266910c5527cb011602514bf88ee1a9e076fd071d78c54e319`.
Exemplo:

    curl -H "Authorization: Token token=0x3f01b98dce38ab266910c5527cb011602514bf88ee1a9e076fd071d78c54e319" http://localhost:3000/quotes/teste

A resposta será:

    [
	    ...
	    {
		    "author":"Albert Einstein",
		    "author_about":"In 1879, Albert Einstein was born in Ulm, Germany. He completed his Ph.D. at the University of Zurich by 1909. His 1905 paper explaining the photoelectric effect, the basis of electronics...",
		    "quote":"There are only two ways to live your life. One is as though nothing is a miracle. The other is as though everything is a miracle.",
	 		"tags":["inspirational","life","live","miracle","miracles"]
		}
		...
    ]

## Arquitetura

Para construir a aplicação foi criada uma simples rota `GET` que ativa uma biblioteca criada chamada `QuoteCrawler` responsável por receber um termo de busca e devolver as frases relacionadas a ele.

A lib trabalha da seguinte forma: caso o termo já tenha sido pesquisado, a biblioteca retorna as frases salvas no banco de dados. Caso contrário, consulta o site utilizando um *web crawler*, salva as informações das frases no banco de dados para utilizar como cache nas próximas consultas, e retorna para o controller exibir os dados.

Quando a biblioteca realiza a busca pelas informações de frases no site, ela busca as informações na listagem de frases: nome do autor, tags e a frase. Para salvar os dados sobre o autor, é realizada uma segunda consulta para o atributo `href` do link correspondente a descrição do autor de cada frase.

Para salvar as informações no banco de dados é utilizada a seguinte arquitetura de documentos (models):
**Search**: term (*string, termo de pesquisa*)
**Quote**: quote (*string, texto da frase*), author (*string, autor da frase*), author_about (*string, texto sobre o autor*), tags: (*array, tags cadastradas na frase*), search: (*relacionamento **Search** que representa a busca a qual pertence esta frase*).

## Considerações

 - Conforme descrito na especificação usada como motivação para este projeto, são salvos apenas os registros da primeira página acessada no crawler.
 - Foi utilizada a gem [Mongoid](https://github.com/mongodb/mongoid) para comunicação do Rails com o MongoDB.
 - Para serializar os objetos da resposta foi criado o seguinte método no model Quote (que é o objeto retornado no endpoint):

        def as_json(options={})
          super(except: [:'_id', :search_id])
        end
	Este método é chamado por padrão nas respostas `render json: object` e devolve todos os atributos do model *Quote*, exceto o id do documento no *Mongo DB* e o relacionamento com o model de busca, que não é interessante no retorno.
 - No caso do endpoint ser acessado com um token de acesso inválido ou sem nenhum token de acesso a aplicação retorna o status 401 com a resposta `Bad credentials`.
 - Em caso do endpoint receber um termo e o crawler não encontrar nenhuma frase a resposta é:
 `[]`
