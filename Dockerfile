FROM alpine:latest

RUN apk --no-cache add git python3 py-lxml \
    && rm -rf /var/cache/apk/*

WORKDIR /
RUN git clone https://github.com/stamparm/DSVW
RUN sed -i 's/127.0.0.1/0.0.0.0/g' /DSVW/dsvw.py

RUN sed -i 's/subprocess.check_output/subprocess.run/g' /DSVW/dsvw.py
RUN sed -i 's/shell=True/shell=True, check=False/g' /DSVW/dsvw.py
RUN sed -i 's/PIPE).decode()/PIPE, stdout=subprocess.PIPE).stdout.decode()/g' /DSVW/dsvw.py

RUN sed -i 's/|<a href=\\"%s\\">exploit<\/a>/<!-- %s -->/g' /DSVW/dsvw.py
RUN sed -i 's/|<a href=\\"%s\\" target=\\"_blank\\">info<\/a>/<!-- %s -->/g' /DSVW/dsvw.py
RUN sed -i 's/, ("Denial of Service (<i>memory<\/i>)", "\/?size=32", "\/?size=9999999", "https:\/\/www.owasp.org\/index.php\/Denial_of_Service")//g' /DSVW/dsvw.py

RUN sed -i 's/\"Full Path Disclosure\", \"\/?path=\"/\"Full Path Disclosure\", \"\/?path=1\"/g' /DSVW/dsvw.py
RUN sed -i 's/\"Server Side Request Forgery\", \"\/?path=\"/\"Server Side Request Forgery\", \"\/?path=1\"/g' /DSVW/dsvw.py
RUN sed -i 's/("Cross Site Request Forgery", "\/?comment="/("Cross Site Request Forgery", "\/?comment=1"/g' /DSVW/dsvw.py
RUN sed -i 's/)\", \"\/?include="/)\", \"\/?include=1"/g' /DSVW/dsvw.py


EXPOSE 65412

CMD ["python3", "/DSVW/dsvw.py"]
