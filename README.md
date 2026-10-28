# pod_link

**One capability bit from GBT V8, packaged standalone.** No. 50 of 341,
`creation` domain (Creation).

<p>
<img alt="python" src="https://img.shields.io/badge/python-3.9%2B-blue">
<img alt="license" src="https://img.shields.io/badge/license-MIT-green">
<img alt="deps" src="https://img.shields.io/badge/runtime%20dependencies-0-brightgreen">
</p>

> **云卡触手**（她自己的传输器官：本机 ⇄ GPU 卡 · 在卡上跑命令 · 看卡状态）。op=status/ls/up/down/run/where：`status` 读卡清单（id/状态/价/卷/端口/公网IP）+ Jupyter 通不通；`ls` 列卡上目录；**`up` 本机→卡**（字节级 base64 上传，**传完回读对账 sha256**）；**`down` 卡→本机**（`/files` 取回 + 落盘对账）；**`run` 在卡上跑一段 Python**（内核通道）。常用说法：传上云 / 从卡上取回来 / 在卡上跑 / 卡上现在有什么 / 云卡 / 4090 / GPU 传输 / 上云。铁律：**令牌不回显**（只报已配/未配）· **传完必须回读对账哈希**（不一致一律 ok=false）· **不创建/不删除/不重启 Pod**（花钱动作要主人点头）。

That description is copied verbatim from the registry. `tests/test_spec.py` pins it,
so documentation drift fails the build instead of shipping quietly.

## What this package actually is

It is the **contract** for one capability: its name, its parameters, the values it
accepts, and whether it can change state that cannot be restored. It is not the
implementation — that lives in the runtime this bit was extracted from.

So `run()` goes through a narrow `Backend` protocol, and the default backend is a
stub that **says so**:

```
status="validated"   backend="stub"   data={"executed": false}
```

Never `status="ok"`. A stub that reports success is worse than no stub, because the
caller stops looking for the real thing.

## Install

```bash
git clone https://github.com/gbtweilai-star/gbt-pod-link.git
cd gbt-pod-link
python -m pip install -e ".[dev]"
```

## Use

```bash
python -m gbt_pod_link info                  # capability card
python -m gbt_pod_link spec --json           # machine-readable contract
python -m gbt_pod_link check --payload '{}'
python -m gbt_pod_link run   --payload '{}'
```

Real `info` output from this machine:

```text
pod_link  (creation)  v1.0.0
----------------------------------------
**云卡触手**（她自己的传输器官：本机 ⇄ GPU 卡 · 在卡上跑命令 · 看卡状态）。op=status/ls/up/down/run/where：`status` 读卡清单（id/状态/价/卷/端口/公网IP）+ Jupyter 通不通；`ls` 列卡上目录；**`up` 本机→卡**（字节级 base64 上传，**传完回读对账 sha256**）；**`down` 卡→本机**（`/files` 取回 + 落盘对账）；**`run` 在卡上跑一段 Python**（内核通道）。常用说法：传上云 / 从卡上取回来 / 在卡上跑 / 卡上现在有什么 / 云卡 / 4090 / GPU 传输 / 上云。铁律：**令牌不回显**（只报已配/未配）· **传完必须回读对账哈希**（不一致一律 ok=false）· **不创建/不删除/不重启 Pod**（花钱动作要主人点头）。

gated      : True   <- needs explicit consent
external   : False
multi-op   : True
params     : (none)
values     : status, ls, up, down, run, where
```

Wire a real implementation:

```python
from gbt_pod_link import run

class MyBackend:
    name = "my-backend"
    def invoke(self, cap, payload):
        return {"cap": cap, "handled": sorted(payload)}

result = run({}, backend=MyBackend())
assert result.status == "ok"
```

## Parameters

| name | required | notes |
|---|---|---|
| — | no | the registry declares no required parameters |

Registry hint (`params_hint`): (empty)

**注册表登记的取值 / 子动作（6 个）**：`status`、`ls`、`up`、`down`、`run`、`where`

Types are deliberately absent: the registry does not declare them, and an invented
type is worse than no type, because callers believe it.

## Boundaries

- Gated: this bit is marked `safe: false` in the registry — it can change state that no inverse action restores.
- No external service dependency declared.
- Multi-op (`multi_op: true`): several sub-actions share one name — read `op` before calling.
- No implementation ships here. Bring a backend; the protocol is one method.

## What this is not

Not a wrapper around a hosted API. Not a model. Not a promise that calling it does
anything on its own. It is the typed seam plus the validation, which is the part that
stays correct even when the implementation changes.

## Tests

```bash
python -m pytest
```

```text
20 passed, 3 skipped in 0.11s
```

## Provenance

| field | value |
|---|---|
| capability | `pod_link` |
| domain | `creation` |
| handler | `pod_link` |
| safe | `False` (gated = `True`) |
| external | `False` |
| atlas page | [creation/pod_link](https://github.com/gbtweilai-star/gbt-caps/blob/main/caps/creation/pod_link.md) |
| full index | [https://github.com/gbtweilai-star/gbt-caps](https://github.com/gbtweilai-star/gbt-caps) |

The parent README says 348 capabilities; an AST pass over the registry enumerates
`341 + 0 unimplemented + 0 disabled = 341`. The extra 7 are historical duplicates.
Numbering here follows 341 and matches the `gbt-caps` index one-to-one.

## License

MIT.
