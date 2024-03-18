FROM alpine/git AS base

ARG TAG=latest
RUN git clone https://github.com/Nikke-db/Nikke-db.github.io.git && \
    cd Nikke-db.github.io && \
    ([[ "$TAG" = "latest" ]] || git checkout ${TAG}) && \
    rm -rf .git && \
    for file in c s t v index credits; do \
        for href in c s t v; do \
            sed -i "s/<a href=\"${href}\">/<a href=\"${href}.html\">/" ${file}.html; \
        done; \
        for href in c t v_m s; do \
            sed -i "s/<a href=\"\/${href}\">/<a href=\"${href}.html\">/" ${file}.html; \
        done; \
    done && \
    for file in c s index credits; do \
        sed -i 's/<a href="\/credits">/<a href="credits.html">/' ${file}.html; \
    done; \
    sed -i 's/location.href = "v_m"/location.href = "v_m.html"/' js/visualiser.js && \
    sed -i 's/location.href = "v"/location.href = "v.html"/' js/visualiser_m.js && \
    sed -i 's/navigator.userAgentData.mobile/(navigator.userAgent.includes("Android")||(navigator.userAgent.includes("Mac OS X")) \&\& !navigator.userAgent.includes("Macintosh"))/' js/visualiser_m.js

FROM lipanski/docker-static-website

COPY --from=base /git/Nikke-db.github.io .
