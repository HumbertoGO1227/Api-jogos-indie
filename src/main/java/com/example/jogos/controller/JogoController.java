package com.example.jogos.controller;
import com.example.jogos.entity.Jogo;
import com.example.jogos.repository.JogoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/jogos")
@CrossOrigin(origins = "*")
public class JogoController {

    @Autowired
    private JogoRepository jogoRepository;

    @GetMapping
    public List<Jogo> listarTodos() {
        return jogoRepository.findAll();
    }

    @PostMapping
    public Jogo criar(@RequestBody Jogo jogo) {
        return jogoRepository.save(jogo);
    }

    @PutMapping("/{id}")
    public Jogo atualizar(@PathVariable Long id, @RequestBody Jogo jogoAtualizado) {
        return jogoRepository.findById(id).map(j -> {
            j.setNome(jogoAtualizado.getNome());
            j.setGenero(jogoAtualizado.getGenero());
            j.setPlataforma(jogoAtualizado.getPlataforma());
            j.setAvaliacao(jogoAtualizado.getAvaliacao());
            j.setDescricao(jogoAtualizado.getDescricao());
            j.setUrlImagem(jogoAtualizado.getUrlImagem());
            return jogoRepository.save(j);
        }).orElseThrow();
    }

    @DeleteMapping("/{id}")
    public void deletar(@PathVariable Long id) {
        jogoRepository.deleteById(id);
    }
}
