# AI readiness

The marts are built to be read by AI tools as well as by Power BI.

## In place
- Every mart table and column has a business description in dbt YAML.
- `persist_docs` writes those descriptions to Databricks Unity Catalog as table and column comments. Genie and other LLM tools rely on this metadata to map questions to columns.
- Metric definitions are explicit and tested (net value, average ticket, the 2011 audit).

## Next steps
1. **Genie space** over the marts, with instructions (metric definitions, the sales reason caveat) and the business questions as sample questions.
2. **MCP access for Claude or other assistants:** Databricks exposes a managed MCP endpoint per Genie space, for read-only questions over governed data.
3. **Governance:** a read-only service principal limited to the marts schema.
4. **Evaluation:** reuse the SQL files in `analyses/` as a golden set: the AI answer to each business question must match the SQL answer.
