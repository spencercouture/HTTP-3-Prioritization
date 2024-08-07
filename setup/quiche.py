from setup.process import run
import os
import hashlib
import logging

def start_quiche(addr, port, hostnames, namespace, nsid, directory):
    hostnames = sorted(list(set(hostnames)))
    hostnames_string = ",".join(hostnames)

    m = hashlib.md5()
    m.update(hostnames_string.encode())
    idx = m.hexdigest()
    logging.info("md5 %s %s" % (idx, hostnames_string))

    exe_path = os.path.abspath("quiche/rundir/%s" % (idx))
    if not os.path.exists(exe_path):
        os.makedirs(exe_path)

    path = os.path.abspath("temporary/quiche/%s/%s-%d" % (nsid, idx, port))

    os.makedirs(path, exist_ok=True)

    print("path:")
    print(path)

    print("port:")
    print(port)

    cert_path = os.path.abspath("temporary/certificates/%s" % idx)
    key_filename = cert_path + "/cert.key"
    cert_filename = cert_path + "/cert.crt"

    if not os.path.exists(cert_path):
        logging.info("generate certificates for %s" % hostnames_string)
        os.makedirs(cert_path)
        cert_basename = cert_path + "/cert"

        cert_args = ["./setup/certificates/cert.sh", cert_basename]
        cert_args += hostnames

        run(cert_args)

    add_args = [
        cert_filename,
        key_filename,
        addr + ":" + str(port),
        idx,
        directory
    ]

    print(f"cert: {cert_filename}")
    print(f"key: {key_filename}")

    args = ["bash", "-c", "../../scripts/start-quiche.sh " + " ".join(add_args)]
    
    # call run, but don't return this one...
    # this is because if we do, it will try to copy the files from quiche/rundir
    # instead, we want to copy from our tmp folder, so we return a dummy process
    run(args, None, cwd=exe_path, bg=False, additionalargs={"path":path, "hostnames":hostnames})
    

    dummy_exe_path = os.path.abspath("/tmp/quiche-server-data-%s/%s" % (nsid, idx))
    # the process we return is our noop one. this is because we want the cwd to be our /tmp/ directory so things get copied correctly
    dummy_args = ["bash", "-c", "echo", "hi"]
    p = run(dummy_args, None, cwd=dummy_exe_path, bg=False)
    return p
