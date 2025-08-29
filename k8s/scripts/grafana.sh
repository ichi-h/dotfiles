port=`kubectl get svc -n default grafana -o jsonpath="{.spec.ports[0].nodePort}"`
if [ -z "$port" ]; then
  echo "Grafana service port not found. Ensure Grafana is deployed correctly."
  exit 1
fi

echo Origin: http://localhost:$port
echo Username: admin
echo Password: $(kubectl get secret --namespace default grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo)
kubectl port-forward svc/grafana $port:80 -n default
