import re
import sqlite3


def read(path):
    with open(path, encoding="utf-8") as f:
        return f.read()


con = sqlite3.connect(":memory:")
con.executescript(read("schema.sql"))
con.executescript(read("data.sql"))

out = ["# 쿼리 실행 결과 (schema.sql -> data.sql -> queries.sql 순서로 실행한 결과)", ""]
title = ""
buf = ""

for line in read("queries.sql").splitlines():
    m = re.match(r"--\s*(\d+)\.\s*(.*)", line)
    if m:
        title = f"[{m.group(1)}] {m.group(2)}"
    if not buf and (not line.strip() or line.strip().startswith("--")):
        continue
    buf += line + "\n"
    if not sqlite3.complete_statement(buf):
        continue
    stmt, buf = buf.strip(), ""
    if stmt.upper().startswith("PRAGMA"):
        con.execute(stmt)
        continue
    cur = con.execute(stmt)
    out += [title, stmt, ""]
    if cur.description:
        out.append("\t".join(c[0] for c in cur.description))
        rows = cur.fetchall()
        for row in rows:
            out.append("\t".join("NULL" if v is None else str(v) for v in row))
        out.append(f"-> {len(rows)}행")
    elif cur.rowcount >= 0:
        out.append(f"-> {cur.rowcount}행이 영향 받음")
    else:
        out.append("-> 실행 완료")
    out.append("")

with open("query_results.txt", "w", encoding="utf-8") as f:
    f.write("\n".join(out))
print("query_results.txt 생성 완료")