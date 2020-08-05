# Multiparty Computation Example

1. Clone the repository
    ```sh
    git clone git clone git@github.com:cogeorg/teaching.git
    ```

2. Navigate inside the directory
    ```sh
    cd your/path/to/Multiparty_Computation_Example
    ```

3. Build the docker image
    ```sh
    docker build . -t multiparty-computation-minimal:0.1.0
    ```

4. Run the docker container
    ```sh
    docker run -it -p 5000:5000 --network="host" --env PORT=5000 multiparty-computation-minimal:0.1.0
    ```
    Note that all the ports need to be the same (here:5000). 
    
    To run the container detached, run the following command instead:
    ```sh
    docker run -d -p 5000:5000 --network="host" --env PORT=5000 multiparty-computation-minimal:0.1.0
    ```
To run the multiparty computation example locally, you will need to run several instances of this docker image (otherwise there are no multiple parties ;-) ), e.g. another one on port 5001 and another one on 5002.

5. Communicate the parties (you need [httpie](https://httpie.org/) for the following commands)
    ```sh
    http POST http://localhost:5000/members members:='["http://127.0.0.1:5000","http://127.0.0.1:5001","http://127.0.0.1:5002"]'
    http POST http://localhost:5001/members members:='["http://127.0.0.1:5000","http://127.0.0.1:5001","http://127.0.0.1:5002"]'
    http POST http://localhost:5002/members members:='["http://127.0.0.1:5000","http://127.0.0.1:5001","http://127.0.0.1:5002"]'
    ```

6. Compute an average using multiparty computation
    ```sh
    http POST http://localhost:5000/compute-average data=4 data_id = 1
    http POST http://localhost:5001/compute-average data=12 data_id = 1
    http POST http://localhost:5002/compute-average data=17 data_id = 1
    ```
    Note that you also pass a data id. This allows you to conduct multiple rounds of computing.

    The result should be 11.