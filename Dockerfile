# Dockerfile
FROM ruby:3.2.6

# Instalar dependências
RUN apt-get update -qq && \
    apt-get install -y nodejs postgresql-client && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . .

RUN bundle install

# Adicionar o script de entrada
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000 3001

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]