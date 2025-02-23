FROM python:3.11-buster as builder 
WORKDIR /app
RUN pip install --upgrade pip && pip install poetry
COPY pyproject.toml poetry.lock ./
RUN poetry config virtualenvs.create false \
    && poetry install --no-root --no-interaction --no-ansi

FROM python:3.11-buster as app
WORKDIR /app 
# i think this is right DOUBLE CHECK
COPY --from=builder /app /app
COPY --from=builder /usr /usr 
EXPOSE 8000
ENV PATH="$PATH:/app/.venv/bin"
CMD ["uvicorn", "cc_compose.server:app", "--reload", "--host", "0.0.0.0", "--port", "8000"]

