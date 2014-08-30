pf-yapc-asia-tokyo-agent
========================

YAPC::Asia::Tokyo 感想ブログをtwitterから取得する何か

## Usage

    git clone git@github.com:umeyuki/pf-yapc-asia-tokyo-agent.git
    cd pf-yapc-asia-tokyo-agent
    carton install
    carton exec -- ppit set api.twitter.com # consumer_keyなどをセット
    carton exec -- perl  agent.pl --date=2014-08-30
