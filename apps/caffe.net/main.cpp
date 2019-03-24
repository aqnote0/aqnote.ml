
#include<vector>
#include<iostream>
#include<caffe/net.hpp>

using namespace std;
using namespace caffe;

void shutdown_log(){
    google::InitGoogleLogging("Net");
    FLAGS_stderrthreshold = google::ERROR;
}

void clean_log()
{
    google::ShutdownGoogleLogging();            
}

int main(int argc,char** argv)
{
    shutdown_log();
    string proto("./input/face-detection-retail-0004.prototxt");
#if 1
    Net<float> Net_test(proto,caffe::TEST);

    string netname=Net_test.name();
    cout << "network_name:"<<netname<<endl;

    vector<string> bn=Net_test.blob_names();
    for(int i = 0;i<bn.size();i++)
    {   
        cout<<"Blob #"<<i<<" : "<<bn[i]<<endl;
    }   


    vector<string> ln=Net_test.layer_names();
    for(int i = 0;i<bn.size();i++)
    {   
        cout<<"Layers #"<<i<<" : "<<ln[i]<<endl;
    }   
#endif
    clean_log();
    return 0;
}