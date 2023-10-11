FROM ruby:2.7-alpine

# Set up dependencies
ENV BUILD_PACKAGES="build-base curl git" \
		DEV_PACKAGES="bzip2-dev libgcrypt-dev libxml2-dev libxslt-dev openssl-dev mysql-client mysql-dev postgresql-dev sqlite-dev zlib-dev" \
		RAILS_DEPS="ca-certificates nodejs tzdata" \
		RAILS_VERSION="5.2.8.1" 
		
# Install our dependencies and rails
RUN \
	apk add --no-cache --update --upgrade --virtual .railsdeps \
			$BUILD_PACKAGES $DEV_PACKAGES $RAILS_DEPS \
	&& gem install bundler \
	&& gem install rails \
	&& rm -rf /var/cache/apk/* \
	&& mkdir -p /home/hydra

ENV RAILS_ENV development
ENV RACK_ENV development

WORKDIR /home/hydra
ADD ./hydra /home/hydra
RUN bundle install --jobs=4 --retry=3
