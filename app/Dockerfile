FROM ruby:2.5.0
#
RUN mkdir /app
#
# RUN mkdir /app/fixer
# ADD . /app/fixer
#
WORKDIR /app
ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock
# RUN bundle config local.fixer /fixer
RUN bundle install --jobs=8 --without development
ADD . /app
CMD ["unicorn", "-c", "./config/unicorn.rb"]
