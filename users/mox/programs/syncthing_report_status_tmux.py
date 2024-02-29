from urllib import request
import json
import argparse

def get_syncthing_rest_response(url, path, key):
  response = None
  with request.urlopen(request.Request("http://" + url + path , headers={"X-API-Key": key})) as encoded_response:
    response = json.loads(encoded_response.read().decode('utf-8'))
  return response

# TODO: fix...
api_key = "gwAqXYNRA52NiWeKMepcFLA9Fs2oP53r"
local_syncthing_url = "127.0.0.1:8384"

try:
  is_up = (get_syncthing_rest_response(
    local_syncthing_url, "/rest/system/ping", api_key)
         == {"ping": "pong"})
except:
  is_up = False

out_of_sync_upload_files = 0
out_of_sync_download_files = 0
errors = 0
folder_hashes = []

if is_up:
  
  folder_hashes = list(get_syncthing_rest_response(
      local_syncthing_url, "/rest/stats/folder", api_key).keys())


  for folder in folder_hashes:
    folder_status =  get_syncthing_rest_response(
        local_syncthing_url, "/rest/db/status?folder=" + folder, api_key)
    errors += folder_status["errors"]
    out_of_sync_upload_files += folder_status["needFiles"]
    out_of_sync_download_files += folder_status["globalFiles"] \
        - folder_status["inSyncFiles"] - folder_status["needFiles"]
  
parser = argparse.ArgumentParser()
parser.add_argument("--fg-color", type=str,
                    help="tmux foreground color name",
                    default="default")
parser.add_argument("--bg-color", type=str,
                    help="tmux foreground color name",
                    default="default")
args = parser.parse_args()
if (is_up and errors == 0 and
    (out_of_sync_upload_files + out_of_sync_download_files) == 0):
# All synced, no problems
  symbol_foreground = "colour47"
elif (is_up and errors == 0):
# syncing, but no errors
  symbol_foreground = "colour33"
elif is_up:
# errors, but still up
  symbol_foreground = "colour226"
else:
# syncthing is not up
  symbol_foreground = "colour196"

sync_symbol = " " if is_up else " "

print("#[fg=" + symbol_foreground + ",bg=" + args.bg_color + ",bold]" + sync_symbol + " #[fg=" + args.fg_color + "]" + str(len(folder_hashes)) + " 󰉕  " + str(out_of_sync_upload_files) + "󰞙 " + str(out_of_sync_download_files) +"󰞒 " )
