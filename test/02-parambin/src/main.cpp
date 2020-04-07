#include <iostream>
#include <stdlib.h>

int main(int argc, char** argv)
{
	std::cout << "argc = " << argc << std::endl;
	for (int i = 0; i < argc; ++i) {
		std::cout << "argv[" << i << "] = '" << argv[i] << "'" << std::endl;
	}
	return EXIT_SUCCESS;
}
