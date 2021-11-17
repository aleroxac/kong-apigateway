# kong-apigateway


## Como configurar o Kong API Gateway
- Suba docker-compose do Kong
- Faça o setup inicial do Kong
    1. Acesse o dashboard do Konga atravéz do endereço localhost:1337
    2. Preencha os dados de usuário, email e senha
    3. Logue-se com as credenciais criadas anteriormente
    4. Uma vez logado, deixe "Kong API" no campo "Nome" e campo "Kong Admin URL" deixe "http://kong:8001" e então vá em "Create Connection"
    5. Daqui em diante você pode fazer a configuração dos services, routes, plugins e consumers via UI ou via API
- Suba o docker-compose de metricas
- Suba o docker-compose de logging
- Suba o docker-compose dos serviços



## Configure os services e suas respectivas rotas
```bash
# Criando os serviços
# DOC: https://docs.konghq.com/enterprise/2.5.x/admin-api/#add-service
curl -X POST http://localhost:8001/services --data 'name=servicea' --data 'url=http://servicea:8081'
curl -X POST http://localhost:8001/services --data 'name=serviceb' --data 'url=http://serviceb:8082'
curl -X POST http://localhost:8001/services --data 'name=servicec' --data 'url=http://servicec:8083'

# Criando as rotas
# DOC: https://docs.konghq.com/enterprise/2.5.x/admin-api/#add-route
curl -X POST http://localhost:8001/services/servicea/routes --data 'name=routea' --data 'paths[]=/a'
curl -X POST http://localhost:8001/services/serviceb/routes --data 'name=routeb' --data 'paths[]=/b'
curl -X POST http://localhost:8001/services/servicec/routes --data 'name=routec' --data 'paths[]=/c'
```



## Teste o API gateway
```bash
# Associando o plugin de autenticação via API Key a um serviço
# DOC: https://docs.konghq.com/enterprise/2.5.x/admin-api/#add-plugin
curl -X POST http://localhost:8001/services/servicea/plugins --data 'name=key-auth'

# Criando user e sua respectiva key
# DOC: https://docs.konghq.com/enterprise/2.5.x/admin-api/#add-consumer
curl -X POST http://localhost:8001/consumers --data 'username=testevaldo'
curl -X POST http://localhost:8001/consumers/testevaldo/key-auth --data 'key=testevaldo123'

# Testando rotas
curl -v -X GET http://localhost:8000/a -H 'apikey: testevaldo123'
curl -v -X GET http://localhost:8000/b
curl -v -X GET http://localhost:8000/c
```



## FAQ
    ### Principais tipos de autenticação suportados?
    - Basic Auth
    - API Key
    - JWT
    - OAuth2
    - LDAP

    ### É possível fazer o controle de autorização em minhas APIs usando o Kong?
    - Até existe um plugin de ACL, embora eu não tenha conseguido utilizar, me pareceu bem básico.

    ### Posso criar meus próprios plugins para utilizar no Kong?
    - Por padrão, os plugins podem ser criados usando as linguagens Lua e Golang, mas também existem PDKs para Javascript e Python.

    ### Quais recursos o Kong oferece?
    - Gateway
    - Load Balancing
    - Rate Limiting
    - Retry / Circuit Breaker
    - Service Discovery
    - Response Caching
    - Logging / Tracing
    - IP Whitelisting
    - Query Transformation
    - CORS



## Pros vs Contras
    ### Pros
    - Documentação muito boa
    - Facilidade de encontrar apoio nas comunidades online
    - Quantidade de recursos nativos
    - Possibilidade de rodar o Kong com database(PostgreSQL ou Cassandra) ou sem(in-memory storage)
    ### Contras
    - Single point of failure
    - Ter que fazer deploy e administração por conta própria



## Referências
- https://github.com/codeedu/apigateway-kong
- https://www.youtube.com/playlist?list=PLte2beIMI39Kl80hl789YFKnpLvql8Kmw
- https://docs.konghq.com/install/docker/
- https://docs.konghq.com/gateway-oss/2.5.x/kong-for-kubernetes/install/
- https://docs.konghq.com/hub/?_ga=2.82477662.970138766.1631225307-795138378.1630437103
- https://docs.konghq.com/hub/plugins/overview/
- https://docs.konghq.com/gateway-oss/2.5.x/plugin-development/
- https://docs.konghq.com/enterprise/2.4.x/external-plugins/
