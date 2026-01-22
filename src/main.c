#include <SDL.h>
#include <stdbool.h>
#include <math.h>

int main(int argc, char *argv[])
{
    (void)argc;
    (void)argv;

    if (SDL_Init(SDL_INIT_VIDEO) != 0)
    {
        SDL_Log("SDL_Init failed: %s", SDL_GetError());
        return 1;
    }

    SDL_Window *window = SDL_CreateWindow(
        "SopraCube2 (SDL2)",
        SDL_WINDOWPOS_CENTERED,
        SDL_WINDOWPOS_CENTERED,
        960,
        540,
        SDL_WINDOW_SHOWN);

    if (!window)
    {
        SDL_Log("SDL_CreateWindow failed: %s", SDL_GetError());
        SDL_Quit();
        return 1;
    }
    int carre[4][2] = {
        {-100, 0},
        {0, -100},
        {100, 0},
        {0, 100},
    };
    SDL_Renderer *renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC);
    if (!renderer)
    {
        SDL_Log("SDL_CreateRenderer failed: %s", SDL_GetError());
        SDL_DestroyWindow(window);
        SDL_Quit();
        return 1;
    }
    int deltay = 270;
    int deltax = 480;
    int teta = 0;
    bool running = true;
    while (running)
    {
        SDL_Event e;
        while (SDL_PollEvent(&e))
        {
            if (e.type == SDL_QUIT)
            {
                running = false;
            }
            if (e.type == SDL_KEYDOWN && e.key.keysym.sym == SDLK_ESCAPE)
            {
                running = false;
            }
            if (e.type == SDL_KEYDOWN && e.key.keysym.sym == SDLK_z)
            {
                deltay = deltay - 10;
            }
            if (e.type == SDL_KEYDOWN && e.key.keysym.sym == SDLK_q)
            {
                deltax = deltax - 10;
            }
            if (e.type == SDL_KEYDOWN && e.key.keysym.sym == SDLK_s)
            {
                deltay = deltay + 10;
            }
            if (e.type == SDL_KEYDOWN && e.key.keysym.sym == SDLK_d)
            {
                deltax = deltax + 10;
            }
            if (e.type == SDL_KEYDOWN && e.key.keysym.sym == SDLK_e)
            {
                teta = teta - 2;
            }
            if (e.type == SDL_KEYDOWN && e.key.keysym.sym == SDLK_a)
            {
                teta = teta + 2;
            }
        }

        SDL_SetRenderDrawColor(renderer, 18, 18, 24, 255);
        SDL_RenderClear(renderer);

        // SDL_Rect rect = { 100, 100, 300, 300 };
        SDL_SetRenderDrawColor(renderer, 26, 198, 193, 1);
        //.SDL_RenderFillRect(renderer, &rect);
        SDL_RenderDrawLine(renderer,
                           (cos(teta) * carre[2][0] - sin(teta) * carre[2][1]) + deltax,
                           (sin(teta) * carre[2][0] + cos(teta) * carre[2][1]) + deltay,
                           (cos(teta) * carre[3][0] - sin(teta) * carre[3][1]) + deltax,
                           (sin(teta) * carre[3][0] + cos(teta) * carre[3][1]) + deltay);
        SDL_RenderDrawLine(renderer,
                           (cos(teta) * carre[0][0] - sin(teta) * carre[0][1]) + deltax,
                           (sin(teta) * carre[0][0] + cos(teta) * carre[0][1]) + deltay,
                           (cos(teta) * carre[1][0] - sin(teta) * carre[1][1]) + deltax,
                           (sin(teta) * carre[1][0] + cos(teta) * carre[1][1]) + deltay);
        SDL_RenderDrawLine(renderer,
                           (cos(teta) * carre[3][0] - sin(teta) * carre[3][1]) + deltax,
                           (sin(teta) * carre[3][0] + cos(teta) * carre[3][1]) + deltay,
                           (cos(teta) * carre[0][0] - sin(teta) * carre[0][1]) + deltax,
                           (sin(teta) * carre[0][0] + cos(teta) * carre[0][1]) + deltay);
        SDL_RenderDrawLine(renderer,
                           (cos(teta) * carre[1][0] - sin(teta) * carre[1][1]) + deltax,
                           (sin(teta) * carre[1][0] + cos(teta) * carre[1][1]) + deltay,
                           (cos(teta) * carre[2][0] - sin(teta) * carre[2][1]) + deltax,
                           (sin(teta) * carre[2][0] + cos(teta) * carre[2][1]) + deltay);
        SDL_RenderPresent(renderer);
    }

    SDL_DestroyRenderer(renderer);
    SDL_DestroyWindow(window);
    SDL_Quit();
    return 0;
}
